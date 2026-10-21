import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import {
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { test } from 'node:test';

import {
  buildIndex,
  checkDocument,
  claimsCiParity,
  commandShape,
  inlineCode,
  instructionFiles,
  pathResolver,
  stripFences,
} from './check_instruction_claims.mjs';

function write(root, path, content) {
  mkdirSync(dirname(join(root, path)), { recursive: true });
  writeFileSync(join(root, path), content);
}

function createRepository(files = {}) {
  const root = mkdtempSync(join(tmpdir(), 'instruction-claims-'));
  execFileSync('git', ['init', '--initial-branch=main'], { cwd: root });
  for (const [path, content] of Object.entries(files)) write(root, path, content);
  execFileSync('git', ['add', '.'], { cwd: root });
  return root;
}

function removeRepository(root) {
  rmSync(root, { recursive: true, force: true });
}

const pathExists = pathResolver({
  tracked: new Set([
    'AGENTS.md',
    'ARCHITECTURE.md',
    'lib/core/routing/app_route.dart',
    'lib/core/theme/colors/app_colors.dart',
    'scripts/ci/check_instruction_claims.mjs',
    'scripts/ci/check_instruction_claims.test.mjs',
    'test/domain/user_test.dart',
    '.claude/rules/dart-navigation.md',
  ]),
  isIgnored: target => target === '.env' || target === '.claude/last-session-status.json',
});

const analyzeShape = commandShape('flutter analyze');
const claimsShape = commandShape('node scripts/ci/check_instruction_claims.mjs');
const index = {
  pathExists,
  repoRoots: pathExists.repoRoots,
  appClasses: new Map([
    ['AppRoute', new Set(['login', 'signUp'])],
    ['AppColors', new Set(['primary100'])],
    ['AppEmpty', new Set()],
  ]),
  workflowCommands: [analyzeShape, claimsShape],
  workflowCommandKeys: new Set([
    JSON.stringify(analyzeShape),
    JSON.stringify(claimsShape),
  ]),
};

const check = (text, path = 'README.md') =>
  checkDocument({ path, text, index }).map(violation => violation.message);

test('path resolution accepts Git-visible files, directories, and ignored local paths', () => {
  assert.ok(pathExists('lib/core/routing/app_route.dart'));
  assert.ok(pathExists('lib/core/routing'));
  assert.ok(pathExists('lib/core/routing/'));
  assert.ok(pathExists('.env'));
  assert.ok(pathExists('.claude/last-session-status.json'));
  assert.ok(!pathExists('lib/core/routing/missing.dart'));
});

test('repository path claims reject missing concrete paths', () => {
  assert.deepEqual(check('Read `ARCHITECTURE.md` and `lib/core/routing/app_route.dart`.'), []);
  assert.match(check('Read `lib/core/routing/missing.dart`.')[0], /does not have/);
  assert.match(check('Read `MISSING_GUIDE.md`.')[0], /does not have/);
});

test('globs, placeholders, ellipses, and illustrative paths remain valid template prose', () => {
  assert.deepEqual(check('Match `lib/**/*.dart` and `.claude/rules/*.md`.'), []);
  assert.deepEqual(check('Read `lib/manifests/<feature>.manifest.generated.json`.'), []);
  assert.deepEqual(check('Inspect `lib/presentation/{feature}/`.'), []);
  assert.deepEqual(check('A flow may own `test/...`.'), []);
  assert.deepEqual(check('Extract `widgets/feature_content.dart`.'), []);
  assert.deepEqual(check('Create `docs/PROJECT_SPEC.md` after discovery.'), []);
  assert.deepEqual(
    check('Never create `lib/core/routing/fictional.dart`; this is a negative example.'),
    [],
  );
});

test('App-prefixed class and member citations resolve against live Dart declarations', () => {
  assert.deepEqual(check('Use `AppRoute.login` and `AppColors.primary100`.'), []);
  assert.match(check('Use `AppRoute.logout`.')[0], /does not declare/);
  assert.match(check('Use `AppMotion.standard`.')[0], /no class in lib\/ declares/);
  assert.deepEqual(check('Use `AppRoute.x` or `AppRoute.target` in a template.'), []);
  assert.deepEqual(check('| ❌ | `AppRoute.removed` |'), []);
  assert.deepEqual(check('Use `AppEmpty.anything`.'), [], 'empty extraction is fail-open');
});

test('stale model-layer paths are rejected without rejecting migration examples', () => {
  assert.match(check('Put application models under lib/domain/.')[0], /lib\/models/);
  assert.match(check('Put model tests under test/models/.')[0], /test\/domain/);
  assert.deepEqual(
    check('Reject stale `lib/domain/`; use `lib/models/` instead.'),
    [],
  );
});

test('command shapes normalize FVM and retain runner, action, paths, and flags', () => {
  assert.deepEqual(
    commandShape('fvm dart run scripts/ci/check_instruction_claims.mjs --strict'),
    {
      runner: 'dart',
      action: 'run',
      subject: 'scripts/ci/check_instruction_claims.mjs',
      paths: ['scripts/ci/check_instruction_claims.mjs'],
      flags: ['--strict'],
    },
  );
  assert.deepEqual(
    commandShape(
      'node --test scripts/ai/session_status.test.mjs scripts/ci/check_instruction_claims.test.mjs',
    ),
    {
      runner: 'node',
      action: '--test',
      subject: null,
      paths: [
        'scripts/ai/session_status.test.mjs',
        'scripts/ci/check_instruction_claims.test.mjs',
      ],
      flags: [],
    },
  );
  assert.deepEqual(commandShape('flutter analyze'), analyzeShape);
  assert.equal(commandShape('git diff --check'), null);
});

test('bash commands validate every concrete repository path', () => {
  assert.match(
    check('Run `node scripts/ci/missing.mjs`.')[0],
    /does not have/,
  );
  assert.deepEqual(
    check('Run locally:\n\n```bash\nnode scripts/ci/check_instruction_claims.mjs\n```\n'),
    [],
  );
  assert.match(
    check('Run locally:\n\n```bash\nnode scripts/ci/missing.mjs\n```\n')[0],
    /does not have/,
  );
  assert.deepEqual(
    check('Run locally:\n\n```bash\nflutter test <focused-test-path>\n```\n'),
    [],
  );
});

test('workflow run commands validate repository-backed script paths', () => {
  assert.deepEqual(
    checkDocument({
      path: '.github/workflows/checks.yml',
      text: 'jobs:\n  checks:\n    steps:\n      - run: node scripts/ci/check_instruction_claims.mjs\n',
      index,
    }),
    [],
  );
  const violations = checkDocument({
    path: '.github/workflows/checks.yml',
    text: 'jobs:\n  checks:\n    steps:\n      - run: node scripts/ci/missing.mjs\n',
    index,
  });
  assert.match(violations[0].message, /does not have/);
});

test('commands claiming CI parity must match the workflow inventory', () => {
  assert.ok(claimsCiParity('This is what CI runs'));
  assert.ok(!claimsCiParity('Run this locally'));
  assert.deepEqual(
    check('This is what CI runs:\n\n```bash\nflutter analyze\n```\n'),
    [],
  );
  assert.match(
    check('This is what CI runs:\n\n```bash\nflutter test\n```\n')[0],
    /claims parity with CI/,
  );
});

test('fenced examples are excluded from prose and inline-code path extraction', () => {
  const text = 'before\n```markdown\n`lib/missing.dart`\nlib/domain/\n```\nafter';
  assert.equal(stripFences(text).split('\n').length, 6);
  assert.ok(!stripFences(text).includes('lib/domain'));
  assert.deepEqual(inlineCode(text), []);
  assert.deepEqual(check(text), []);
});

test('learning logs are excluded from point-in-time instruction validation', () => {
  assert.deepEqual(
    checkDocument({
      path: 'docs/LEARNING_LOG.md',
      text: 'Old `AppRoute.removed` used lib/domain/.',
      index,
    }),
    [],
  );
});

test('instruction inventory covers roots, nested guides, rules, skills, agents, and workflows', () => {
  const root = mkdtempSync(join(tmpdir(), 'instruction-files-'));
  try {
    for (const path of [
      'AGENTS.md',
      'CLAUDE.md',
      'ARCHITECTURE.md',
      'README.md',
      'lib/AGENTS.md',
      'docs/GUIDE.md',
      'docs/LEARNING_LOG.md',
      '.claude/rules/example.md',
      '.claude/skills/example/SKILL.md',
      '.claude/agents/example.md',
      '.github/workflows/checks.yml',
    ]) {
      write(root, path, 'fixture\n');
    }
    const files = instructionFiles(root);
    assert.ok(files.includes('ARCHITECTURE.md'));
    assert.ok(files.includes('lib/AGENTS.md'));
    assert.ok(files.includes('.claude/skills/example/SKILL.md'));
    assert.ok(files.includes('.claude/agents/example.md'));
    assert.ok(files.includes('.claude/rules/example.md'));
    assert.ok(files.includes('.github/workflows/checks.yml'));
    assert.ok(!files.includes('docs/LEARNING_LOG.md'));
  } finally {
    removeRepository(root);
  }
});

test('discovered documents keep archive exemptions and live checks across platforms', () => {
  const root = mkdtempSync(join(tmpdir(), 'instruction-claims[fixture]-'));
  try {
    const text = 'See `lib/removed.dart`.';
    write(root, 'docs/LEARNING_LOG.md', text);
    write(root, 'docs/CURRENT.md', text);

    const paths = instructionFiles(root);
    assert.deepEqual(paths, ['docs/CURRENT.md']);
    const violations = paths.flatMap(path =>
      checkDocument({ path, text: readFileSync(join(root, path), 'utf8'), index }),
    );
    assert.equal(violations.length, 1);
    assert.equal(violations[0].path, 'docs/CURRENT.md');
    assert.match(violations[0].message, /lib\/removed\.dart/);
  } finally {
    removeRepository(root);
  }
});

test('buildIndex extracts live App members, untracked files, and workflow command shapes', () => {
  const root = createRepository({
    'lib/core/routing/app_route.dart': [
      'class AppRoute {',
      "  static const String login = '/login';",
      "  static String mutable = '/mutable';",
      '  static String forUser(String id) {',
      '    final localOnly = id;',
      '    return "/users/$localOnly";',
      '  }',
      '}',
      '',
    ].join('\n'),
    'lib/core/theme/app_colors.dart': [
      'abstract class AppColors {',
      '  Color get primary;',
      '}',
      '',
    ].join('\n'),
    '.github/workflows/checks.yml': [
      'jobs:',
      '  checks:',
      '    steps:',
      '      - run: |',
      '          flutter analyze',
      '          node scripts/ci/check_instruction_claims.mjs',
      '',
    ].join('\n'),
    'README.md': 'fixture\n',
  });

  try {
    write(root, 'scripts/ci/check_instruction_claims.mjs', '// untracked fixture\n');
    const built = buildIndex(root);
    assert.deepEqual(
      [...built.appClasses.get('AppRoute')].sort(),
      ['forUser', 'login', 'mutable'],
    );
    assert.ok(!built.appClasses.get('AppRoute').has('localOnly'));
    assert.deepEqual([...built.appClasses.get('AppColors')], ['primary']);
    assert.ok(built.pathExists('scripts/ci/check_instruction_claims.mjs'));
    assert.ok(
      built.workflowCommands.some(
        shape => shape.runner === 'flutter' && shape.action === 'analyze',
      ),
    );
    assert.ok(
      built.workflowCommands.some(
        shape => shape.paths.includes('scripts/ci/check_instruction_claims.mjs'),
      ),
    );
  } finally {
    removeRepository(root);
  }
});
