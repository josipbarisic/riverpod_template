import assert from 'node:assert/strict';
import { mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';

import {
  CONFIG_PATH,
  TYPES,
  assessIssue,
  main,
  missingHeadings,
  parentShouldClose,
  previousReleaseTag,
  rankReady,
  statusForClosedIssue,
  statusForClosedParent,
  statusForPullRequest,
} from './project.mjs';

const REPO = 'owner/app';
const CONFIG = { owner: 'owner', number: 7, repository: REPO };

const FEATURE_BODY = ['Summary', 'Acceptance criteria', 'Approach', 'Context', 'QA']
  .map(heading => `### ${heading}\n\ntext`)
  .join('\n\n');

function issue(number, overrides = {}) {
  return {
    id: `I_${number}`,
    number,
    title: `Issue ${number}`,
    url: `https://github.com/${REPO}/issues/${number}`,
    state: 'OPEN',
    stateReason: null,
    body: FEATURE_BODY,
    labels: { nodes: [{ name: 'type:feature' }] },
    parent: null,
    subIssues: { totalCount: 0, nodes: [] },
    blockedBy: { nodes: [] },
    closedByPullRequestsReferences: { nodes: [] },
    projectItems: { nodes: [] },
    ...overrides,
  };
}

function onProject(status) {
  return {
    projectItems: {
      nodes: [{ project: { number: 7, owner: { login: 'owner' } }, fieldValueByName: { name: status } }],
    },
  };
}

/** A `gh` stand-in over an in-memory repository that records every mutating call. */
function fakeGh({ issues = {}, closing = {}, items = [], releases = [], compare = [], commitPulls = {}, comments = {} }) {
  const calls = [];
  const gh = args => {
    calls.push(args);
    const joined = args.join(' ');
    if (args[0] === 'api' && args[1] === 'graphql') {
      const variable = name => args.find(arg => arg.startsWith(`${name}=`))?.split('=')[1];
      if (joined.includes('addProjectV2ItemById')) {
        return JSON.stringify({ data: { addProjectV2ItemById: { item: { id: `item-${variable('content')}` } } } });
      }
      if (joined.includes('updateProjectV2ItemFieldValue')) {
        return JSON.stringify({ data: { updateProjectV2ItemFieldValue: { projectV2Item: { id: variable('item') } } } });
      }
      if (joined.includes('items(first')) {
        const nodes = items.map(item => ({
          status: item.status ? { name: item.status } : null,
          priority: item.priority ? { name: item.priority } : null,
          content: { __typename: 'Issue', number: item.content.number, title: item.title, repository: { nameWithOwner: item.content.repository } },
        }));
        const page = { pageInfo: { hasNextPage: false, endCursor: null }, nodes };
        return JSON.stringify({ data: { repositoryOwner: { projectV2: { items: page } } } });
      }
      if (joined.includes('repositoryOwner')) {
        const options = ['Backlog', 'Ready', 'In progress', 'In review', 'Merged', 'Done'].map(name => ({ id: name, name }));
        return JSON.stringify({ data: { repositoryOwner: { projectV2: { id: 'P_7', field: { id: 'F_status', options } } } } });
      }
      const number = Number(variable('number'));
      if (joined.includes('pullRequest(number')) {
        const nodes = (closing[number] ?? []).map(n => ({ number: n }));
        return JSON.stringify({ data: { repository: { pullRequest: { closingIssuesReferences: { nodes } } } } });
      }
      return JSON.stringify({ data: { repository: { issue: issues[number] ?? null } } });
    }
    if (joined.startsWith('release list')) return JSON.stringify(releases);
    if (args[0] === 'api' && args.some(arg => arg.includes('/compare/'))) return compare.join('\n');
    if (args[0] === 'api' && args[1].includes('/commits/')) {
      const sha = args[1].split('/commits/')[1].split('/')[0];
      return (commitPulls[sha] ?? []).join('\n');
    }
    if (joined.startsWith('issue view')) return (comments[Number(args[2])] ?? []).join('\n');
    if (joined.startsWith('project copy')) {
      return JSON.stringify({ number: 9, url: 'https://github.com/users/owner/projects/9' });
    }
    return '';
  };
  const writes = () =>
    calls.filter(args =>
      ['link', 'copy'].includes(args[1]) ||
      args.some(arg => arg.includes('mutation(')) ||
      (args[0] === 'issue' && ['close', 'comment'].includes(args[1])) ||
      (args[0] === 'label' && args[1] === 'create'),
    );
  const statuses = () =>
    calls
      .filter(args => args.some(arg => arg.includes('updateProjectV2ItemFieldValue')))
      .map(args => {
        const value = name => args.find(arg => arg.startsWith(`${name}=`)).split('=')[1];
        return `${value('item').replace('item-I_', '')}:${value('option')}`;
      });
  return { gh, calls, writes, statuses };
}

function withRepository(config, run) {
  const root = mkdtempSync(join(tmpdir(), 'project-'));
  const previous = process.env.GITHUB_REPOSITORY;
  process.env.GITHUB_REPOSITORY = REPO;
  try {
    if (config) {
      mkdirSync(join(root, '.github'), { recursive: true });
      writeFileSync(join(root, CONFIG_PATH), JSON.stringify(config));
    }
    return run(root);
  } finally {
    if (previous === undefined) delete process.env.GITHUB_REPOSITORY;
    else process.env.GITHUB_REPOSITORY = previous;
    rmSync(root, { recursive: true, force: true });
  }
}

function run(argv, fake, root) {
  const lines = [];
  const code = main(argv, { gh: fake.gh, cwd: root, log: line => lines.push(line) });
  return { code, lines };
}

test('an issue with sub-issues, an open blocker, or missing headings is not executable', () => {
  assert.deepEqual(assessIssue(issue(1)), []);
  assert.match(
    assessIssue(issue(1, { subIssues: { totalCount: 2, nodes: [] } })).join(),
    /has 2 sub-issue/,
  );
  const blocked = issue(1, {
    blockedBy: { nodes: [{ number: 4, state: 'OPEN', repository: { nameWithOwner: REPO } }] },
  });
  assert.match(assessIssue(blocked).join(), /blocked by owner\/app#4/);
  const finishedBlocker = issue(1, {
    blockedBy: { nodes: [{ number: 4, state: 'CLOSED', repository: { nameWithOwner: REPO } }] },
  });
  assert.deepEqual(assessIssue(finishedBlocker), []);
  assert.match(assessIssue(issue(1, { body: '### Summary\n' })).join(), /Acceptance criteria/);
  assert.match(assessIssue(issue(1, { labels: { nodes: [] } })).join(), /exactly one type label/);
});

test('headings match form (###) and hand-written (##) bodies, whole line only', () => {
  assert.deepEqual(missingHeadings('## Summary\n### QA', ['Summary', 'QA']), []);
  assert.deepEqual(missingHeadings('Summary in prose\n### Summaryish', ['Summary']), ['Summary']);
});

test('pull request events map to In review, Merged, and back to In progress; drafts do nothing', () => {
  assert.equal(statusForPullRequest({ action: 'opened', pull_request: { draft: false } }), 'In review');
  assert.equal(statusForPullRequest({ action: 'opened', pull_request: { draft: true } }), null);
  assert.equal(statusForPullRequest({ action: 'ready_for_review', pull_request: { draft: false } }), 'In review');
  assert.equal(statusForPullRequest({ action: 'closed', pull_request: { merged: true } }), 'Merged');
  assert.equal(statusForPullRequest({ action: 'closed', pull_request: { merged: false } }), 'In progress');
});

test('a closed issue is Merged only when a merged pull request closed it', () => {
  const merged = { nodes: [{ number: 3, merged: true }] };
  assert.equal(statusForClosedIssue(issue(1, { stateReason: 'COMPLETED', closedByPullRequestsReferences: merged })), 'Merged');
  assert.equal(statusForClosedIssue(issue(1, { stateReason: 'COMPLETED' })), 'Done');
  assert.equal(statusForClosedIssue(issue(1, { stateReason: 'NOT_PLANNED', closedByPullRequestsReferences: merged })), 'Done');
});

test('a closed parent stays Merged until every child is released', () => {
  assert.equal(statusForClosedParent(['Done', 'Done']), 'Done');
  assert.equal(statusForClosedParent(['Done', 'Merged']), 'Merged');
  assert.equal(statusForClosedParent(['Done', null]), 'Merged');
});

test('a parent closes only when every loaded sub-issue is closed', () => {
  const children = states => ({ totalCount: states.length, nodes: states.map((state, i) => ({ number: i, state })) });
  assert.equal(parentShouldClose({ state: 'OPEN', subIssues: children(['CLOSED', 'CLOSED']) }), true);
  assert.equal(parentShouldClose({ state: 'OPEN', subIssues: children(['CLOSED', 'OPEN']) }), false);
  assert.equal(parentShouldClose({ state: 'OPEN', subIssues: { totalCount: 3, nodes: children(['CLOSED']).nodes } }), false);
  assert.equal(parentShouldClose({ state: 'CLOSED', subIssues: children(['CLOSED']) }), false);
});

test('ready ranks by Priority, then issue number, unprioritised last', () => {
  const ranked = rankReady([
    { number: 5, priority: 'P2' },
    { number: 9 },
    { number: 3, priority: 'P0' },
    { number: 1, priority: 'P2' },
  ]);
  assert.deepEqual(ranked.map(item => item.number), [3, 1, 5, 9]);
});

test('the previous release is the one published before the tag', () => {
  const releases = [
    { tagName: 'v1.1.0', isDraft: false, publishedAt: '2026-02-01T00:00:00Z' },
    { tagName: 'v1.0.0', isDraft: false, publishedAt: '2026-01-01T00:00:00Z' },
    { tagName: 'v1.2.0', isDraft: true, publishedAt: null },
  ];
  assert.equal(previousReleaseTag(releases, 'v1.1.0'), 'v1.0.0');
  assert.equal(previousReleaseTag(releases, 'v1.0.0'), null);
});

test('check exits 1 and names every problem', () => {
  const fake = fakeGh({ issues: { 2: issue(2, { subIssues: { totalCount: 1, nodes: [] } }) } });
  withRepository(CONFIG, root => {
    const { code, lines } = run(['check', '2'], fake, root);
    assert.equal(code, 1);
    assert.match(lines.join('\n'), /sub-issue/);
    assert.deepEqual(fake.writes(), []);
  });
});

test('ready lists only this repository\'s executable Ready issues', () => {
  const item = (number, status, priority, repository = REPO) => ({
    status,
    priority,
    title: `Issue ${number}`,
    content: { type: 'Issue', number, repository },
  });
  const fake = fakeGh({
    items: [item(1, 'Ready', 'P2'), item(2, 'Ready', 'P0'), item(3, 'Backlog', 'P0'), item(4, 'Ready', 'P0', 'owner/other'), item(5, 'Ready', 'P1')],
    issues: { 1: issue(1), 2: issue(2), 5: issue(5, { subIssues: { totalCount: 1, nodes: [] } }) },
  });
  withRepository(CONFIG, root => {
    const { lines } = run(['ready'], fake, root);
    assert.deepEqual(lines, ['#2 [P0] Issue 2', '#1 [P2] Issue 1']);
  });
});

test('sync moves closing issues to In review, then Merged, and never pulls a merged one back', () => {
  const fake = fakeGh({ closing: { 10: [1, 2] }, issues: { 1: issue(1), 2: issue(2, onProject('Merged')) } });
  withRepository(CONFIG, root => {
    const eventPath = join(root, 'event.json');
    writeFileSync(eventPath, JSON.stringify({ action: 'opened', pull_request: { number: 10, draft: false } }));
    run(['sync', '--event-name=pull_request', `--event-path=${eventPath}`], fake, root);
    assert.deepEqual(fake.statuses(), ['1:In review']);

    const merged = fakeGh({ closing: { 10: [1] }, issues: { 1: issue(1, onProject('In review')) } });
    writeFileSync(eventPath, JSON.stringify({ action: 'closed', pull_request: { number: 10, merged: true } }));
    run(['sync', '--event-name=pull_request', `--event-path=${eventPath}`], merged, root);
    assert.deepEqual(merged.statuses(), ['1:Merged']);
  });
});

test('sync on a closed sub-issue sets its Status and closes the finished parent', () => {
  const child = issue(2, {
    state: 'CLOSED',
    stateReason: 'COMPLETED',
    parent: { number: 1, state: 'OPEN' },
    closedByPullRequestsReferences: { nodes: [{ number: 10, merged: true }] },
    ...onProject('In review'),
  });
  const parent = issue(1, { subIssues: { totalCount: 2, nodes: [{ number: 2, state: 'CLOSED' }, { number: 3, state: 'CLOSED' }] } });
  const fake = fakeGh({ issues: { 1: parent, 2: child } });
  withRepository(CONFIG, root => {
    const eventPath = join(root, 'event.json');
    writeFileSync(eventPath, JSON.stringify({ action: 'closed', issue: { number: 2 } }));
    run(['sync', '--event-name=issues', `--event-path=${eventPath}`], fake, root);
    assert.deepEqual(fake.statuses(), ['2:Merged']);
    assert.ok(fake.calls.some(args => args[0] === 'issue' && args[1] === 'close' && args[2] === '1'));
  });
});

test('release pages through the range and moves its Merged issues to Done with one comment', () => {
  const releases = [
    { tagName: 'v1.1.0', isDraft: false, publishedAt: '2026-02-01T00:00:00Z' },
    { tagName: 'v1.0.0', isDraft: false, publishedAt: '2026-01-01T00:00:00Z' },
  ];
  const base = {
    releases,
    compare: ['aaa', 'bbb'],
    commitPulls: { aaa: ['10'], bbb: ['11'] },
    closing: { 10: [1], 11: [2] },
    issues: { 1: issue(1, { state: 'CLOSED', ...onProject('Merged') }), 2: issue(2, { state: 'CLOSED', ...onProject('Done') }) },
  };
  const commentCount = fake => fake.calls.filter(args => args[0] === 'issue' && args[1] === 'comment').length;
  withRepository(CONFIG, root => {
    const fake = fakeGh(base);
    run(['release', '--tag=v1.1.0'], fake, root);
    const compare = fake.calls.find(args => args.some(arg => arg.includes('/compare/')));
    assert.ok(compare.includes('--paginate'), 'the compare API caps one response at 250 commits');
    assert.ok(compare.some(arg => arg.endsWith('?per_page=100')));
    assert.deepEqual(fake.statuses(), ['1:Done']);
    assert.equal(commentCount(fake), 1);

    // A rerun after success finds the issue Done and leaves it alone.
    const rerun = fakeGh({ ...base, issues: { ...base.issues, 1: issue(1, { state: 'CLOSED', ...onProject('Done') }) } });
    run(['release', '--tag=v1.1.0'], rerun, root);
    assert.deepEqual(rerun.statuses(), []);
    assert.equal(commentCount(rerun), 0);

    // A rerun after the status write failed finds the comment and only finishes the status.
    const retry = fakeGh({ ...base, comments: { 1: ['Released in v1.1.0.\n\n<!-- released-in: v1.1.0 -->'] } });
    run(['release', '--tag=v1.1.0'], retry, root);
    assert.deepEqual(retry.statuses(), ['1:Done']);
    assert.equal(commentCount(retry), 0);
    // A failed comment leaves the issue Merged, so the next run posts it.
    const failing = fakeGh(base);
    const throwOnComment = args => {
      if (args[0] === 'issue' && args[1] === 'comment') throw new Error('comment failed');
      return failing.gh(args);
    };
    assert.throws(() => main(['release', '--tag=v1.1.0'], { gh: throwOnComment, cwd: root, log: () => {} }), /comment failed/);
    assert.deepEqual(failing.statuses(), []);
  });
});

test('a pull request closed unmerged returns only its In review issues to In progress', () => {
  const fake = fakeGh({
    closing: { 10: [1, 2, 3] },
    issues: { 1: issue(1, onProject('In review')), 2: issue(2, onProject('Merged')), 3: issue(3, onProject('Ready')) },
  });
  withRepository(CONFIG, root => {
    const eventPath = join(root, 'event.json');
    writeFileSync(eventPath, JSON.stringify({ action: 'closed', pull_request: { number: 10, merged: false } }));
    run(['sync', '--event-name=pull_request', `--event-path=${eventPath}`], fake, root);
    assert.deepEqual(fake.statuses(), ['1:In progress']);
  });
});

test('bootstrap is a dry run by default and skips a repository that already has its project', () => {
  withRepository({ owner: 'owner', number: 1, repository: 'owner/template' }, root => {
    const dry = fakeGh({});
    const { lines } = run(['bootstrap'], dry, root);
    assert.match(lines.join('\n'), /Dry run/);
    assert.deepEqual(dry.writes(), []);

    const applied = fakeGh({});
    run(['bootstrap', '--apply'], applied, root);
    const config = JSON.parse(readFileSync(join(root, CONFIG_PATH), 'utf8'));
    assert.deepEqual(config, { owner: 'owner', number: 9, repository: REPO });
    assert.ok(applied.calls.some(args => args[1] === 'link' && args.includes(REPO)));
    assert.equal(applied.calls.filter(args => args[0] === 'label').length, 5);

    const again = fakeGh({});
    const second = run(['bootstrap', '--apply'], again, root);
    assert.match(second.lines.join(), /already tracks/);
    assert.deepEqual(again.writes(), []);
  });
});

test('each issue form carries its type label and exactly the headings check requires', () => {
  const forms = new URL('../../.github/ISSUE_TEMPLATE/', import.meta.url);
  for (const [label, type] of Object.entries(TYPES)) {
    const text = readFileSync(new URL(`${label.replace('type:', '')}.yml`, forms), 'utf8');
    assert.match(text, new RegExp(`^labels:\\n  - ${label}$`, 'm'), label);
    const headings = [...text.matchAll(/^ {6}label: (.+)$/gm)].map(match => match[1]);
    assert.deepEqual(headings, type.headings, label);
  }
});

test('sync corrects the built-in Done at close: merged work is Merged, a closed parent follows its children', () => {
  const leaf = issue(2, {
    state: 'CLOSED',
    stateReason: 'COMPLETED',
    closedByPullRequestsReferences: { nodes: [{ number: 10, merged: true }] },
    ...onProject('Done'),
  });
  const parent = issue(1, {
    state: 'CLOSED',
    stateReason: 'COMPLETED',
    subIssues: { totalCount: 1, nodes: [{ number: 2, state: 'CLOSED' }] },
    ...onProject('Done'),
  });
  const fake = fakeGh({ issues: { 1: parent, 2: { ...leaf, ...onProject('Merged') } } });
  const leafFake = fakeGh({ issues: { 2: leaf } });
  withRepository(CONFIG, root => {
    const eventPath = join(root, 'event.json');
    writeFileSync(eventPath, JSON.stringify({ action: 'closed', issue: { number: 2 } }));
    run(['sync', '--event-name=issues', `--event-path=${eventPath}`], leafFake, root);
    assert.deepEqual(leafFake.statuses(), ['2:Merged']);

    writeFileSync(eventPath, JSON.stringify({ action: 'closed', issue: { number: 1 } }));
    run(['sync', '--event-name=issues', `--event-path=${eventPath}`], fake, root);
    assert.deepEqual(fake.statuses(), ['1:Merged']);
  });
});
