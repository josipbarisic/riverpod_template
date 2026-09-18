import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import {
  appendFileSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import test from 'node:test';

import {
  isInstructionFile,
  runIntegrityCheck,
  unresolvedClaims,
} from './integrity_check.mjs';
import {
  buildSummary,
  changedFiles,
  detectBase,
  pendingCodegen,
  staleManifests,
} from './session_status.mjs';

function git(cwd, ...args) {
  return execFileSync('git', args, {
    cwd,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  }).trim();
}

function write(root, path, content) {
  mkdirSync(dirname(join(root, path)), { recursive: true });
  writeFileSync(join(root, path), content);
}

function createRepository(files = {}) {
  const root = mkdtempSync(join(tmpdir(), 'riverpod-template-hooks-'));
  for (const [path, content] of Object.entries(files)) write(root, path, content);
  git(root, 'init', '--initial-branch=main');
  git(root, 'config', 'user.name', 'Hook Policy Test');
  git(root, 'config', 'user.email', 'hook-policy@example.invalid');
  git(root, 'add', '.');
  git(root, 'commit', '-m', 'fixture');
  return root;
}

function removeRepository(root) {
  rmSync(root, { recursive: true, force: true });
}

test('Stop integrity matches every CI-scanned instruction surface', () => {
  for (const path of [
    'AGENTS.md',
    'CLAUDE.md',
    'ARCHITECTURE.md',
    'README.md',
    'lib/AGENTS.md',
    'docs/TESTING_STRATEGY.md',
    '.claude/rules/dart-state.md',
    '.claude/skills/example/SKILL.md',
    '.claude/agents/reviewer.md',
    '.cursor/rules/dart-state.mdc',
    '.cursor/commands/test.md',
    '.github/workflows/validate-ai-standards.yml',
  ]) {
    assert.ok(isInstructionFile(path), path);
  }
  assert.ok(!isInstructionFile('lib/presentation/home/home_view.dart'));
  assert.ok(!isInstructionFile('docs/LEARNING_LOG.json'));
});

test('Stop integrity loads the source-backed checker for changed skills', async () => {
  const validator = readFileSync(
    new URL('../ci/check_instruction_claims.mjs', import.meta.url),
    'utf8',
  );
  const root = createRepository({
    'scripts/ci/check_instruction_claims.mjs': validator,
    'lib/core/routing/app_route.dart':
      "class AppRoute {\n  static const String login = '/login';\n}\n",
    '.claude/skills/example/SKILL.md': 'Use `AppRoute.login`.\n',
  });
  try {
    write(
      root,
      '.claude/skills/example/SKILL.md',
      'Use `AppRoute.removed`.\n',
    );
    const claims = await unresolvedClaims(
      ['.claude/skills/example/SKILL.md'],
      { cwd: root },
    );
    assert.equal(claims.length, 1);
    assert.match(claims[0], /AppRoute\.removed/);
  } finally {
    removeRepository(root);
  }
});

test('base detection selects the closest available branch', () => {
  const root = createRepository({ 'README.md': 'fixture\n' });
  try {
    git(root, 'checkout', '-b', 'develop');
    appendFileSync(join(root, 'README.md'), 'develop\n');
    git(root, 'add', 'README.md');
    git(root, 'commit', '-m', 'develop fixture');
    git(root, 'checkout', '-b', 'feature/hooks');

    assert.equal(detectBase('feature/hooks', { cwd: root }), 'develop');
    assert.match(buildSummary({ cwd: root }), /^- Branch: feature\/hooks \(base: develop\)$/m);
  } finally {
    removeRepository(root);
  }
});

test('changed files include worktree, untracked, and both rename paths', () => {
  const root = createRepository({
    'lib/old.dart': 'const oldValue = 1;\n',
    'lib/tracked.dart': 'const trackedValue = 1;\n',
  });
  try {
    appendFileSync(join(root, 'lib/tracked.dart'), 'const changedValue = 2;\n');
    git(root, 'mv', 'lib/old.dart', 'lib/new.dart');
    write(root, 'lib/untracked.dart', 'const untrackedValue = 3;\n');

    assert.deepEqual(
      [...changedFiles({ cwd: root })].sort(),
      ['lib/new.dart', 'lib/old.dart', 'lib/tracked.dart', 'lib/untracked.dart'],
    );
  } finally {
    removeRepository(root);
  }
});

test('flat manifests follow feature, shared generator, and regeneration changes', () => {
  const homeSource = 'lib/presentation/home/home_view.dart';
  const loginSource = 'lib/presentation/login/login_view.dart';
  const homeManifest = 'lib/manifests/home.manifest.generated.json';
  const loginManifest = 'lib/manifests/login.manifest.generated.json';
  const root = createRepository({
    [homeSource]: 'class HomeView {}\n',
    [loginSource]: 'class LoginView {}\n',
    [homeManifest]: `${JSON.stringify({ feature: 'home', views: [homeSource] }, null, 2)}\n`,
    [loginManifest]: `${JSON.stringify({ feature: 'login', views: [loginSource] }, null, 2)}\n`,
    'lib/core/routing/router.dart': 'const routes = <Object>[];\n',
    'lib/presentation/home/home_controller.g.dart': '// generated\n',
  });

  try {
    appendFileSync(join(root, homeSource), '// changed\n');
    assert.deepEqual(staleManifests(undefined, { cwd: root }), ['home']);

    appendFileSync(join(root, homeManifest), '\n');
    assert.deepEqual(staleManifests(undefined, { cwd: root }), []);

    git(root, 'restore', homeSource, homeManifest);
    appendFileSync(join(root, 'lib/core/routing/router.dart'), '// changed\n');
    assert.deepEqual(staleManifests(undefined, { cwd: root }), ['home', 'login']);

    git(root, 'restore', 'lib/core/routing/router.dart');
    appendFileSync(
      join(root, 'lib/presentation/home/home_controller.g.dart'),
      '// regenerated\n',
    );
    assert.deepEqual(staleManifests(undefined, { cwd: root }), []);

    git(root, 'restore', 'lib/presentation/home/home_controller.g.dart');
    write(root, 'lib/presentation/profile/profile_view.dart', 'class ProfileView {}\n');
    assert.deepEqual(staleManifests(undefined, { cwd: root }), ['profile']);
  } finally {
    removeRepository(root);
  }
});

test('codegen diagnostics require every generated partner to change', async () => {
  const riverpodSource = 'lib/presentation/home/home_controller.dart';
  const riverpodOutput = 'lib/presentation/home/home_controller.g.dart';
  const freezedSource = 'lib/models/member/member.dart';
  const freezedOutput = 'lib/models/member/member.freezed.dart';
  const root = createRepository({
    [riverpodSource]: "@riverpod\nclass HomeController {}\npart 'home_controller.g.dart';\n",
    [riverpodOutput]: '// generated\n',
    [freezedSource]: "@freezed\nclass Member {}\npart 'member.freezed.dart';\n",
    [freezedOutput]: '// generated\n',
  });

  try {
    appendFileSync(join(root, riverpodSource), '// changed\n');
    assert.deepEqual(pendingCodegen(undefined, { cwd: root }), [riverpodSource]);
    assert.deepEqual(await runIntegrityCheck({ cwd: root }), {
      ok: false,
      codegen: [riverpodSource],
      manifests: ['home'],
      claims: [],
    });

    appendFileSync(join(root, riverpodOutput), '// regenerated\n');
    assert.deepEqual(pendingCodegen(undefined, { cwd: root }), []);

    appendFileSync(join(root, freezedSource), '// changed\n');
    assert.deepEqual(pendingCodegen(undefined, { cwd: root }), [freezedSource]);
    appendFileSync(join(root, freezedOutput), '// regenerated\n');
    assert.deepEqual(pendingCodegen(undefined, { cwd: root }), []);
  } finally {
    removeRepository(root);
  }
});

test('diagnostics fail open outside git and with unreadable manifest data', async () => {
  const root = mkdtempSync(join(tmpdir(), 'riverpod-template-hooks-no-git-'));
  try {
    write(root, 'lib/manifests/broken.manifest.generated.json', '{');
    assert.equal(detectBase('feature/hooks', { cwd: root }), null);
    assert.deepEqual([...changedFiles({ cwd: root })], []);
    assert.deepEqual(staleManifests(undefined, { cwd: root }), []);
    assert.deepEqual(pendingCodegen(undefined, { cwd: root }), []);
    assert.match(buildSummary({ cwd: root }), /^- Branch: \(unknown\)$/m);
    assert.deepEqual(await runIntegrityCheck({ cwd: root }), {
      ok: true,
      codegen: [],
      manifests: [],
      claims: [],
    });
  } finally {
    removeRepository(root);
  }
});
