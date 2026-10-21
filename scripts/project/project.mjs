#!/usr/bin/env node
// Work tracking on this repository's GitHub Project (v2), driven through `gh`.
//
//   check <n>               is issue #n executable: open, no sub-issues, no open blocker,
//                           one type label, its form's headings present (exit 1 if not)
//   ready [--limit=N]       executable Ready issues, highest Priority first
//   status <n> <Status>     add issue #n to the project and set its Status
//   sync                    Actions entry: PR opened → In review, PR merged → Merged, PR closed
//                           unmerged → back to In progress, issue closed → Merged or Done,
//                           last sub-issue closed → parent closed
//   release --tag=<tag>     Actions entry: issues closed by PRs since the previous release
//                           move Merged → Done with a "Released in <tag>" comment
//   bootstrap [--apply]     copy the source project for this repository, link it, create
//                           the type labels and write .github/project.json (dry run by default)
//
// `.github/project.json` names the project. A repository created from the template inherits the
// template's file; `bootstrap` sees the foreign `repository` and copies that project as the source.

import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

export const CONFIG_PATH = '.github/project.json';
export const STATUSES = ['Backlog', 'Ready', 'In progress', 'In review', 'Merged', 'Done'];

// Each type label and the headings its issue form produces. `plan-issues` writes the same headings.
export const TYPES = {
  'type:feature': {
    color: '1D76DB',
    description: 'New capability',
    headings: ['Summary', 'Acceptance criteria', 'Approach', 'Context', 'QA'],
  },
  'type:improvement': {
    color: '0E8A16',
    description: 'Change to existing behavior',
    headings: ['Summary', 'Current behavior', 'Desired behavior', 'Approach', 'Context', 'QA'],
  },
  'type:bug': {
    color: 'D73A4A',
    description: 'Something is broken',
    headings: ['Summary', 'Steps to reproduce', 'Expected', 'Actual', 'Environment'],
  },
  'type:chore': {
    color: 'BFD4F2',
    description: 'Maintenance with no behavior change',
    headings: ['Summary', 'Approach', 'Context', 'QA'],
  },
  'type:spike': {
    color: 'FBCA04',
    description: 'Time-boxed investigation',
    headings: ['Summary', 'Method', 'Decision output', 'Context'],
  },
};

const PRIORITY_ORDER = ['P0', 'P1', 'P2'];

export const releaseMarker = tag => `<!-- released-in: ${tag} -->`;

export function ghCli(args) {
  return execFileSync('gh', args, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
}

function graphql(gh, query, variables) {
  const args = ['api', 'graphql', '-f', `query=${query}`];
  for (const [key, value] of Object.entries(variables)) {
    args.push(typeof value === 'number' ? '-F' : '-f', `${key}=${value}`);
  }
  return JSON.parse(gh(args)).data;
}

export function readConfig(cwd = process.cwd()) {
  const path = join(cwd, CONFIG_PATH);
  if (!existsSync(path)) return null;
  return JSON.parse(readFileSync(path, 'utf8'));
}

export function currentRepository(gh, env = process.env) {
  if (env.GITHUB_REPOSITORY) return env.GITHUB_REPOSITORY;
  return gh(['repo', 'view', '--json', 'nameWithOwner', '--jq', '.nameWithOwner']).trim();
}

const ISSUE_FIELDS = `
  id number title url state stateReason body
  labels(first: 20) { nodes { name } }
  parent { number state }
  subIssues(first: 100) { totalCount nodes { number state } }
  blockedBy(first: 20) { nodes { number state repository { nameWithOwner } } }
  closedByPullRequestsReferences(first: 10, includeClosedPrs: true) { nodes { number merged } }
  projectItems(first: 10) {
    nodes {
      project { number owner { ... on User { login } ... on Organization { login } } }
      fieldValueByName(name: "Status") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
    }
  }`;

export function fetchIssue(gh, repository, number) {
  const [owner, repo] = repository.split('/');
  const data = graphql(
    gh,
    `query($owner: String!, $repo: String!, $number: Int!) {
      repository(owner: $owner, name: $repo) { issue(number: $number) { ${ISSUE_FIELDS} } }
    }`,
    { owner, repo, number },
  );
  const issue = data.repository.issue;
  if (!issue) throw new Error(`#${number} is not an issue in ${repository}`);
  return issue;
}

export function fetchClosingIssues(gh, repository, pullNumber) {
  const [owner, repo] = repository.split('/');
  const data = graphql(
    gh,
    `query($owner: String!, $repo: String!, $number: Int!) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $number) { closingIssuesReferences(first: 25) { nodes { number } } }
      }
    }`,
    { owner, repo, number: pullNumber },
  );
  return data.repository.pullRequest.closingIssuesReferences.nodes.map(node => node.number);
}

/** The issue's Status on the configured project, or null when it is not on it. */
export function projectStatus(issue, config) {
  const item = issue.projectItems.nodes.find(
    node => node.project.number === config.number && node.project.owner.login === config.owner,
  );
  if (!item) return null;
  return item.fieldValueByName?.name ?? '';
}

export function missingHeadings(body, headings) {
  return headings.filter(heading => {
    const pattern = new RegExp(`^#{2,3}\\s+${heading.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`, 'im');
    return !pattern.test(body ?? '');
  });
}

/** Why issue #n cannot get a branch and a pull request; empty when it can. */
export function assessIssue(issue) {
  const problems = [];
  if (issue.state !== 'OPEN') problems.push(`is ${issue.state.toLowerCase()}`);
  if (issue.subIssues.totalCount > 0) {
    problems.push(
      `has ${issue.subIssues.totalCount} sub-issue(s); work them instead, the parent closes with them`,
    );
  }
  for (const blocker of issue.blockedBy.nodes) {
    if (blocker.state === 'OPEN') {
      problems.push(`is blocked by ${blocker.repository.nameWithOwner}#${blocker.number}`);
    }
  }
  const types = issue.labels.nodes.map(label => label.name).filter(name => name in TYPES);
  if (types.length !== 1) {
    problems.push(`needs exactly one type label (${Object.keys(TYPES).join(', ')})`);
  } else {
    const missing = missingHeadings(issue.body, TYPES[types[0]].headings);
    if (missing.length > 0) problems.push(`body lacks: ${missing.join(', ')}`);
  }
  return problems;
}

export function statusForPullRequest(event) {
  const pr = event.pull_request;
  if (event.action === 'closed') return pr.merged ? 'Merged' : 'In progress';
  if (['opened', 'reopened', 'ready_for_review'].includes(event.action) && !pr.draft) {
    return 'In review';
  }
  return null;
}

/** A closed issue is Merged when a merged pull request closed it, otherwise Done. */
export function statusForClosedIssue(issue) {
  if (issue.stateReason !== 'COMPLETED') return 'Done';
  const merged = issue.closedByPullRequestsReferences.nodes.some(pr => pr.merged);
  return merged ? 'Merged' : 'Done';
}

/** A closed parent is Done once every child is released, Merged until then. */
export function statusForClosedParent(childStatuses) {
  return childStatuses.every(status => status === 'Done') ? 'Done' : 'Merged';
}

export function parentShouldClose(parent) {
  return (
    parent.state === 'OPEN' &&
    parent.subIssues.totalCount > 0 &&
    parent.subIssues.totalCount === parent.subIssues.nodes.length &&
    parent.subIssues.nodes.every(child => child.state === 'CLOSED')
  );
}

export function rankReady(items) {
  const rank = item => {
    const index = PRIORITY_ORDER.indexOf(item.priority);
    return index === -1 ? PRIORITY_ORDER.length : index;
  };
  return [...items].sort((a, b) => rank(a) - rank(b) || a.number - b.number);
}

/** The release published before `tag`, from `gh release list` JSON; null for the first release. */
export function previousReleaseTag(releases, tag) {
  const published = releases
    .filter(release => !release.isDraft && release.publishedAt)
    .sort((a, b) => b.publishedAt.localeCompare(a.publishedAt));
  const index = published.findIndex(release => release.tagName === tag);
  if (index === -1) return published[0]?.tagName ?? null;
  return published[index + 1]?.tagName ?? null;
}

// Project reads and writes go through GraphQL by node ID. `gh project` resolves the owner's type
// first, which needs a scope beyond the project and repo scopes PROJECT_TOKEN carries.
const PROJECT_QUERY = `query($owner: String!, $number: Int!) {
  repositoryOwner(login: $owner) {
    ... on ProjectV2Owner {
      projectV2(number: $number) {
        id
        field(name: "Status") { ... on ProjectV2SingleSelectField { id options { id name } } }
      }
    }
  }
}`;

const projects = new WeakMap();

function projectMeta(gh, config) {
  if (projects.has(config)) return projects.get(config);
  const project = graphql(gh, PROJECT_QUERY, { owner: config.owner, number: config.number })
    .repositoryOwner?.projectV2;
  if (!project) throw new Error(`Project ${config.owner}/${config.number} is not readable with this token`);
  projects.set(config, project);
  return project;
}

export function setStatus(gh, config, issue, status) {
  if (!STATUSES.includes(status)) throw new Error(`Unknown Status "${status}"`);
  const project = projectMeta(gh, config);
  const option = project.field.options.find(candidate => candidate.name === status);
  if (!option) throw new Error(`Project ${config.owner}/${config.number} has no Status "${status}"`);
  const itemId = graphql(
    gh,
    `mutation($project: ID!, $content: ID!) {
      addProjectV2ItemById(input: { projectId: $project, contentId: $content }) { item { id } }
    }`,
    { project: project.id, content: issue.id },
  ).addProjectV2ItemById.item.id;
  graphql(
    gh,
    `mutation($project: ID!, $item: ID!, $field: ID!, $option: String!) {
      updateProjectV2ItemFieldValue(input: {
        projectId: $project, itemId: $item, fieldId: $field, value: { singleSelectOptionId: $option }
      }) { projectV2Item { id } }
    }`,
    { project: project.id, item: itemId, field: project.field.id, option: option.id },
  );
}

/** Project items in the shape `gh project item-list --format json` prints. */
function listProjectItems(gh, config) {
  const items = [];
  let after = null;
  do {
    const page = graphql(
      gh,
      `query($owner: String!, $number: Int!, $after: String) {
        repositoryOwner(login: $owner) {
          ... on ProjectV2Owner {
            projectV2(number: $number) {
              items(first: 100, after: $after) {
                pageInfo { hasNextPage endCursor }
                nodes {
                  status: fieldValueByName(name: "Status") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
                  priority: fieldValueByName(name: "Priority") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
                  content { __typename ... on Issue { number title repository { nameWithOwner } } }
                }
              }
            }
          }
        }
      }`,
      { owner: config.owner, number: config.number, ...(after ? { after } : {}) },
    ).repositoryOwner.projectV2.items;
    for (const node of page.nodes) {
      if (node.content?.__typename !== 'Issue') continue;
      items.push({
        status: node.status?.name,
        priority: node.priority?.name,
        title: node.content.title,
        content: { type: 'Issue', number: node.content.number, repository: node.content.repository.nameWithOwner },
      });
    }
    after = page.pageInfo.hasNextPage ? page.pageInfo.endCursor : null;
  } while (after);
  return items;
}

function requireConfig(cwd) {
  const config = readConfig(cwd);
  if (!config) throw new Error(`${CONFIG_PATH} is missing; run: node scripts/project/project.mjs bootstrap`);
  return config;
}

export function commandCheck(gh, { number, cwd, log }) {
  const repository = currentRepository(gh);
  const issue = fetchIssue(gh, repository, number);
  const problems = assessIssue(issue);
  if (problems.length === 0) {
    log(`#${issue.number} is executable: ${issue.title}`);
    return 0;
  }
  log(`#${issue.number} is not executable:`);
  for (const problem of problems) log(`  - ${problem}`);
  return 1;
}

export function commandReady(gh, { cwd, limit, log }) {
  const config = requireConfig(cwd);
  const repository = currentRepository(gh);
  const candidates = listProjectItems(gh, config).filter(
    item => item.content.repository === repository && item.status === 'Ready',
  );
  const ready = rankReady(
    candidates.map(item => ({ number: item.content.number, priority: item.priority, title: item.title })),
  ).filter(item => assessIssue(fetchIssue(gh, repository, item.number)).length === 0);
  if (ready.length === 0) {
    log('No executable Ready issues. Run plan-issues, or move a Backlog issue to Ready.');
    return 0;
  }
  for (const item of ready.slice(0, limit)) log(`#${item.number} [${item.priority ?? '-'}] ${item.title}`);
  return 0;
}

export function commandStatus(gh, { number, status, cwd, log }) {
  const config = requireConfig(cwd);
  const issue = fetchIssue(gh, currentRepository(gh), number);
  setStatus(gh, config, issue, status);
  log(`#${number} → ${status}`);
  return 0;
}

function closeFinishedParent(gh, config, repository, issue, log) {
  if (!issue.parent) return;
  const parent = fetchIssue(gh, repository, issue.parent.number);
  if (!parentShouldClose(parent)) return;
  gh(['issue', 'close', String(parent.number), '--repo', repository, '--reason', 'completed',
    '--comment', 'Every sub-issue is closed.']);
  log(`#${parent.number} closed: every sub-issue is closed`);
}

export function commandSync(gh, { eventName, event, cwd, log }) {
  const config = requireConfig(cwd);
  const repository = currentRepository(gh);
  if (eventName === 'pull_request') {
    const status = statusForPullRequest(event);
    if (!status) return 0;
    for (const number of fetchClosingIssues(gh, repository, event.pull_request.number)) {
      const issue = fetchIssue(gh, repository, number);
      const current = projectStatus(issue, config);
      // A reopened or re-readied pull request never pulls a finished issue back.
      if (status === 'In review' && ['Merged', 'Done'].includes(current)) continue;
      // An abandoned pull request returns only issues it had put In review.
      if (status === 'In progress' && current !== 'In review') continue;
      setStatus(gh, config, issue, status);
      log(`#${number} → ${status} (pull request #${event.pull_request.number})`);
    }
    return 0;
  }
  if (eventName === 'issues' && event.action === 'closed') {
    const issue = fetchIssue(gh, repository, event.issue.number);
    const current = projectStatus(issue, config);
    // The project's built-in "Item closed" rule sets Done at close; this corrects it.
    let status = null;
    if (issue.subIssues.totalCount > 0) {
      const children = issue.subIssues.nodes.map(child => fetchIssue(gh, repository, child.number));
      status = statusForClosedParent(children.map(child => projectStatus(child, config)));
    } else {
      status = statusForClosedIssue(issue);
    }
    if (status !== current) {
      setStatus(gh, config, issue, status);
      log(`#${issue.number} → ${status}`);
    }
    closeFinishedParent(gh, config, repository, issue, log);
    return 0;
  }
  log(`Nothing to sync for ${eventName}${event.action ? `.${event.action}` : ''}`);
  return 0;
}

function releasedIssueNumbers(gh, repository, config, tag) {
  const releases = JSON.parse(
    gh(['release', 'list', '--repo', repository, '--limit', '100', '--json', 'tagName,isDraft,publishedAt']),
  );
  const previous = previousReleaseTag(releases, tag);
  if (!previous) {
    return listProjectItems(gh, config)
      .filter(item => item.content.repository === repository && item.status === 'Merged')
      .map(item => item.content.number);
  }
  // The compare API returns 250 commits per response unless paginated.
  const shas = gh(['api', '--paginate', `repos/${repository}/compare/${previous}...${tag}?per_page=100`, '--jq', '.commits[].sha'])
    .split('\n')
    .filter(Boolean);
  const pulls = new Set();
  for (const sha of shas) {
    const numbers = gh(['api', `repos/${repository}/commits/${sha}/pulls`, '--jq', '.[] | select(.merged_at) | .number']);
    for (const number of numbers.split('\n').filter(Boolean)) pulls.add(Number(number));
  }
  const issues = new Set();
  for (const pull of pulls) {
    for (const number of fetchClosingIssues(gh, repository, pull)) issues.add(number);
  }
  return [...issues];
}

export function commandRelease(gh, { tag, cwd, log }) {
  const config = requireConfig(cwd);
  const repository = currentRepository(gh);
  const marker = releaseMarker(tag);
  const parents = new Set();
  for (const number of releasedIssueNumbers(gh, repository, config, tag)) {
    const issue = fetchIssue(gh, repository, number);
    if (projectStatus(issue, config) !== 'Merged') continue;
    // Comment before Done: a rerun skips Done issues, so a comment left for later would never post.
    const comments = gh(['issue', 'view', String(number), '--repo', repository, '--json', 'comments', '--jq', '.comments[].body']);
    if (!comments.includes(marker)) {
      gh(['issue', 'comment', String(number), '--repo', repository, '--body', `Released in ${tag}.\n\n${marker}`]);
    }
    setStatus(gh, config, issue, 'Done');
    log(`#${number} → Done (${tag})`);
    if (issue.parent) parents.add(issue.parent.number);
  }
  for (const number of parents) {
    const parent = fetchIssue(gh, repository, number);
    const children = parent.subIssues.nodes.map(child => fetchIssue(gh, repository, child.number));
    if (parent.state === 'CLOSED' && children.every(child => projectStatus(child, config) === 'Done')) {
      setStatus(gh, config, parent, 'Done');
      log(`#${number} → Done (every sub-issue released)`);
    }
  }
  return 0;
}

export function commandBootstrap(gh, { apply, cwd, log, write = writeFileSync }) {
  const repository = currentRepository(gh);
  const [owner, name] = repository.split('/');
  const existing = readConfig(cwd);
  if (existing?.repository === repository) {
    log(`${repository} already tracks project ${existing.owner}/${existing.number}; nothing to do.`);
    return 0;
  }
  if (!existing) throw new Error(`${CONFIG_PATH} is missing, so there is no source project to copy.`);
  const steps = [
    `copy project ${existing.owner}/${existing.number} as "${name}" for ${owner}`,
    `link the new project to ${repository}`,
    `create or update labels: ${Object.keys(TYPES).join(', ')}`,
    `write ${CONFIG_PATH}`,
  ];
  if (!apply) {
    log('Dry run. With --apply this would:');
    for (const step of steps) log(`  - ${step}`);
    return 0;
  }
  const copied = JSON.parse(
    gh(['project', 'copy', String(existing.number), '--source-owner', existing.owner,
      '--target-owner', owner, '--title', name, '--format', 'json']),
  );
  gh(['project', 'link', String(copied.number), '--owner', owner, '--repo', repository]);
  for (const [label, type] of Object.entries(TYPES)) {
    gh(['label', 'create', label, '--repo', repository, '--color', type.color,
      '--description', type.description, '--force']);
  }
  const config = { owner, number: copied.number, repository };
  write(join(cwd, CONFIG_PATH), `${JSON.stringify(config, null, 2)}\n`);
  log(`Project ${copied.url} is linked to ${repository}.`);
  log('Two steps are yours:');
  log(`  1. In ${copied.url}/workflows: enable "Auto-add to project" for ${repository}, point`);
  log('     "Item closed" at Done and "Pull request merged" at Merged.');
  log('  2. Create a classic token with the project and repo scopes, then run');
  log(`     gh secret set PROJECT_TOKEN --repo ${repository}`);
  return 0;
}

function parseOptions(argv) {
  const positional = [];
  const options = {};
  for (const arg of argv) {
    const match = /^--([^=]+)(?:=(.*))?$/.exec(arg);
    if (match) options[match[1]] = match[2] ?? true;
    else positional.push(arg);
  }
  return { positional, options };
}

export function main(argv = process.argv.slice(2), { gh = ghCli, cwd = process.cwd(), log = console.log } = {}) {
  const [command, ...rest] = argv;
  const { positional, options } = parseOptions(rest);
  switch (command) {
    case 'check':
      return commandCheck(gh, { number: Number(positional[0]), cwd, log });
    case 'ready':
      return commandReady(gh, { cwd, limit: Number(options.limit ?? 10), log });
    case 'status':
      return commandStatus(gh, { number: Number(positional[0]), status: positional.slice(1).join(' '), cwd, log });
    case 'sync': {
      const event = JSON.parse(readFileSync(options['event-path'] ?? process.env.GITHUB_EVENT_PATH, 'utf8'));
      return commandSync(gh, { eventName: options['event-name'] ?? process.env.GITHUB_EVENT_NAME, event, cwd, log });
    }
    case 'release':
      return commandRelease(gh, { tag: options.tag, cwd, log });
    case 'bootstrap':
      return commandBootstrap(gh, { apply: options.apply === true, cwd, log });
    default:
      log('Usage: project.mjs check <n> | ready [--limit=N] | status <n> <Status> | sync | release --tag=<tag> | bootstrap [--apply]');
      return 2;
  }
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? '').href) {
  try {
    process.exitCode = main();
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
