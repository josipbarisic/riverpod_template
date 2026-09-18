// Shared, local session diagnostics for the Cursor and Claude hook adapters.
// Git state is authoritative: checkout mtimes never create false stale results.

import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { basename, join, relative } from 'node:path';

export const BASE_CANDIDATES = ['develop', 'main', 'master'];
export const BUILD_RUNNER_COMMAND = 'dart run build_runner build -d';
export const MANIFEST_COMMAND = 'dart run scripts/generate_feature_manifests.dart';

const PROTECTED_BRANCHES = new Set(['main', 'master']);
const MANIFEST_DIR = 'lib/manifests';
const MANIFEST_SUFFIX = '.manifest.generated.json';
const GLOBAL_MANIFEST_INPUTS = new Set([
  'lib/core/routing/app_route.dart',
  'lib/core/routing/router.dart',
  'lib/core/utils/network/endpoints.dart',
  'scripts/generate_feature_manifests.dart',
]);
const DIRECT_SOURCE_KEYS = ['views', 'controllers', 'widgets', 'models', 'repositories'];

/**
 * Build the concise status injected at session start.
 * @param {{cwd?:string}} [options]
 */
export function buildSummary({ cwd = process.cwd() } = {}) {
  const branch = currentBranch({ cwd });
  const base = BASE_CANDIDATES.includes(branch) ? null : detectBase(branch, { cwd });
  const changed = changedFiles({ cwd });
  const stale = staleManifests(changed, { cwd });
  const pending = pendingCodegen(changed, { cwd });
  const lines = ['riverpod-template session status:', branchLine(branch, base)];

  if (stale.length === 0) {
    lines.push('- Manifests: fresh');
  } else {
    lines.push(`- Manifests: ${stale.length} may be stale — run: ${MANIFEST_COMMAND}`);
    lines.push(`    · ${stale.join(', ')}`);
  }

  if (pending.length === 0) {
    lines.push('- Codegen: up to date');
  } else {
    lines.push(
      `- Codegen: ${pending.length} changed source(s) need build_runner — run: ` +
        BUILD_RUNNER_COMMAND,
    );
    for (const path of pending.slice(0, 8)) lines.push(`    · ${path}`);
  }

  return lines.join('\n');
}

/** @param {{cwd?:string}} [options] */
export function currentBranch({ cwd = process.cwd() } = {}) {
  return git(['symbolic-ref', '--quiet', '--short', 'HEAD'], { cwd }) || '(unknown)';
}

/** @param {string} branch @param {string|null} base */
export function branchLine(branch, base) {
  const parts = [`- Branch: ${branch}`];
  if (base) parts.push(`(base: ${base})`);
  if (PROTECTED_BRANCHES.has(branch)) {
    parts.push('⚠ working directly on a protected branch — create a feature branch');
  } else if (base && PROTECTED_BRANCHES.has(base)) {
    parts.push(`⚠ branched from ${base} — feature branches should start from develop`);
  }
  return parts.join(' ');
}

/**
 * Return the candidate whose merge-base with HEAD is most recent.
 * Missing refs and non-git directories intentionally produce null.
 * @param {string} branch
 * @param {{cwd?:string}} [options]
 */
export function detectBase(branch, { cwd = process.cwd() } = {}) {
  if (!branch || branch === '(unknown)') return null;

  let best = null;
  let bestTime = -1;
  for (const candidate of BASE_CANDIDATES) {
    if (candidate === branch) continue;
    for (const ref of [`origin/${candidate}`, candidate]) {
      const mergeBase = git(['merge-base', 'HEAD', ref], { cwd });
      if (!mergeBase) continue;
      const time = Number(git(['show', '-s', '--format=%ct', mergeBase], { cwd })) || 0;
      if (time > bestTime) {
        best = candidate;
        bestTime = time;
      }
      break;
    }
  }
  return best;
}

/**
 * Return staged, unstaged, renamed, deleted, and untracked paths.
 * Both sides of a rename are retained because either can belong to a manifest.
 * @param {{cwd?:string}} [options]
 */
export function changedFiles({ cwd = process.cwd() } = {}) {
  const status = git(
    ['status', '--porcelain=v1', '-z', '--untracked-files=all'],
    { cwd, trim: false },
  );
  if (!status) return new Set();

  const changed = new Set();
  const records = status.split('\0');
  for (let index = 0; index < records.length; index += 1) {
    const record = records[index];
    if (!record) continue;
    const state = record.slice(0, 2);
    const path = normalizeRepoPath(record.slice(3));
    if (path) changed.add(path);
    if ((state.includes('R') || state.includes('C')) && records[index + 1]) {
      changed.add(normalizeRepoPath(records[index + 1]));
      index += 1;
    }
  }
  return changed;
}

/**
 * Find flat feature manifests affected by changed generator inputs.
 * A changed manifest is treated as regenerated; content comparison belongs to CI.
 * @param {Iterable<string>} [changed]
 * @param {{cwd?:string}} [options]
 */
export function staleManifests(changed, { cwd = process.cwd() } = {}) {
  const changedPaths = new Set(
    [...(changed ?? changedFiles({ cwd }))].map(normalizeRepoPath).filter(Boolean),
  );
  if (changedPaths.size === 0) return [];

  const manifests = readFlatManifests(cwd);
  const stale = new Set();

  for (const { data, path } of manifests) {
    const feature = manifestFeature(data, path);
    if (changedPaths.has(path)) continue;
    if ([...changedPaths].some(changedPath => manifestDependsOn(data, feature, changedPath))) {
      stale.add(feature);
    }
  }

  const knownFeatures = new Set(manifests.map(({ data, path }) => manifestFeature(data, path)));
  for (const path of changedPaths) {
    const match = /^lib\/presentation\/([^/]+)\//.exec(path);
    const feature = match?.[1];
    if (feature && feature !== 'widgets' && !knownFeatures.has(feature)) stale.add(feature);
  }

  return [...stale].sort();
}

/**
 * Find changed annotated Dart sources whose generated partners did not change.
 * @param {Iterable<string>} [changed]
 * @param {{cwd?:string}} [options]
 */
export function pendingCodegen(changed, { cwd = process.cwd() } = {}) {
  const changedPaths = new Set(
    [...(changed ?? changedFiles({ cwd }))].map(normalizeRepoPath).filter(Boolean),
  );
  const pending = [];

  for (const path of changedPaths) {
    if (!path.endsWith('.dart')) continue;
    if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) continue;

    let content;
    try {
      content = readFileSync(join(cwd, path), 'utf8');
    } catch {
      continue;
    }

    const base = path.slice(0, -'.dart'.length);
    const partners = [];
    if (/@(?:riverpod|Riverpod|JsonSerializable)\b/.test(content)) {
      partners.push(`${base}.g.dart`);
    }
    if (/@(?:freezed|Freezed)\b/.test(content)) {
      partners.push(`${base}.freezed.dart`);
    }
    if (partners.some(partner => !changedPaths.has(partner))) pending.push(path);
  }

  return pending.sort();
}

function readFlatManifests(cwd) {
  const directory = join(cwd, MANIFEST_DIR);
  let entries;
  try {
    entries = readdirSync(directory, { withFileTypes: true });
  } catch {
    return [];
  }

  const manifests = [];
  for (const entry of entries) {
    if (!entry.isFile() || !entry.name.endsWith(MANIFEST_SUFFIX)) continue;
    const absolutePath = join(directory, entry.name);
    try {
      manifests.push({
        data: JSON.parse(readFileSync(absolutePath, 'utf8')),
        path: normalizeRepoPath(relative(cwd, absolutePath)),
      });
    } catch {
      // Advisory hooks fail open on unreadable or partially-written manifests.
    }
  }
  return manifests;
}

function manifestFeature(data, path) {
  if (typeof data.feature === 'string' && data.feature) return data.feature;
  return basename(path, MANIFEST_SUFFIX);
}

function manifestDependsOn(data, feature, changedPath) {
  if (GLOBAL_MANIFEST_INPUTS.has(changedPath)) return true;
  if (isGeneratedDart(changedPath)) return false;
  if (pathIsWithin(changedPath, `lib/presentation/${feature}`)) return true;
  if (pathIsWithin(changedPath, `test/presentation/${feature}`)) return true;
  if (pathIsWithin(changedPath, repositoryDirectory(feature))) return true;

  if (pathIsWithin(changedPath, 'test/test_data')) {
    const compactFeature = feature.replaceAll('_', '');
    const file = basename(changedPath).toLowerCase().replaceAll('_', '');
    if (file.includes(compactFeature)) return true;
  }

  return [...collectManifestSources(data)].some(source =>
    pathIsWithin(changedPath, source),
  );
}

function repositoryDirectory(feature) {
  if (feature === 'login' || feature === 'sign_up') {
    return 'lib/data/repositories/auth_repository';
  }
  return `lib/data/repositories/${feature}_repository`;
}

function collectManifestSources(data) {
  const sources = new Set();
  const add = value => {
    if (typeof value === 'string' && value) sources.add(normalizeRepoPath(value));
  };
  for (const key of DIRECT_SOURCE_KEYS) {
    if (Array.isArray(data[key])) data[key].forEach(add);
  }
  for (const key of ['providers', 'stateClasses']) {
    if (Array.isArray(data[key])) data[key].forEach(item => add(item?.file));
  }
  if (Array.isArray(data.apiEndpoints)) {
    for (const endpoint of data.apiEndpoints) {
      add(endpoint?.repository);
      if (Array.isArray(endpoint?.usedIn)) endpoint.usedIn.forEach(add);
    }
  }
  for (const key of ['coreServices', 'thirdPartyDependencies']) {
    if (!Array.isArray(data[key])) continue;
    for (const item of data[key]) {
      add(item?.path);
      if (Array.isArray(item?.usedIn)) item.usedIn.forEach(add);
    }
  }
  if (data.controllerMethods && typeof data.controllerMethods === 'object') {
    for (const methods of Object.values(data.controllerMethods)) {
      if (Array.isArray(methods)) methods.forEach(method => add(method?.file));
    }
  }
  if (data.testing && typeof data.testing === 'object') {
    add(data.testing.testDirectory);
    if (Array.isArray(data.testing.testFiles)) data.testing.testFiles.forEach(add);
    if (Array.isArray(data.testing.testDataFiles)) data.testing.testDataFiles.forEach(add);
  }
  return sources;
}

function pathIsWithin(path, source) {
  const normalizedSource = normalizeRepoPath(source).replace(/\/+$/, '');
  return path === normalizedSource || path.startsWith(`${normalizedSource}/`);
}

function isGeneratedDart(path) {
  return path.endsWith('.g.dart') || path.endsWith('.freezed.dart');
}

export function normalizeRepoPath(value) {
  return String(value ?? '')
    .replace(/^"|"$/g, '')
    .replaceAll('\\', '/')
    .replace(/^\.\//, '');
}

function git(args, { cwd, trim = true }) {
  try {
    const output = execFileSync('git', args, {
      cwd,
      encoding: 'utf8',
      maxBuffer: 16 * 1024 * 1024,
      stdio: ['ignore', 'pipe', 'ignore'],
      timeout: 1500,
    });
    return trim ? output.trim() : output;
  } catch {
    return '';
  }
}
