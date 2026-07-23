// Session-start status summary for the Cursor sessionStart hook.
//
// Imported by .cursor/hooks/session-start.mjs. Everything here is local
// (git + fs) and designed to finish well under 2s — no network / API calls.
//
// Reports three things, each as a concise line:
//   1. Current branch + the base it most likely diverged from (warns on master/main).
//   2. Manifest freshness — presentation source newer than its generated manifest.
//   3. Pending codegen — changed @riverpod/@freezed sources whose generated
//      partner has not been regenerated.

import { execSync } from 'node:child_process';
import { existsSync, readFileSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';

const PROTECTED = new Set(['master', 'main']);
const BASE_CANDIDATES = ['develop', 'main', 'master'];
const MANIFEST_DIR = 'lib/manifests';
// Source-file arrays inside a manifest whose mtime we compare against it.
const SOURCE_KEYS = ['views', 'controllers', 'widgets', 'models', 'repositories'];
// mtime jitter tolerance (ms) so a git checkout doesn't flag everything stale.
const TOLERANCE_MS = 2000;

/** @returns {string} A concise multi-line status summary. */
export function buildSummary() {
  const lines = ['Session status:'];

  lines.push(branchLine());

  const stale = staleManifests();
  if (stale.length === 0) {
    lines.push('- Manifests: fresh');
  } else {
    lines.push(
      `- Manifests: ${stale.length} may be stale — run: ` +
        'dart run scripts/generate_feature_manifests.dart',
    );
    lines.push(`    · ${stale.join(', ')}`);
  }

  const pending = pendingCodegen();
  if (pending.length === 0) {
    lines.push('- Codegen: up to date');
  } else {
    lines.push(
      `- Codegen: ${pending.length} changed source(s) need build_runner — run: ` +
        'dart run build_runner build -d',
    );
    for (const f of pending.slice(0, 8)) lines.push(`    · ${f}`);
  }

  return lines.join('\n');
}

function branchLine() {
  const branch = git('rev-parse --abbrev-ref HEAD') || '(unknown)';
  const base = detectBase(branch);
  const parts = [`- Branch: ${branch}`];
  if (base) parts.push(`(base: ${base})`);
  if (PROTECTED.has(branch)) {
    parts.push('⚠ working directly on a protected branch — create a feature branch');
  } else if (base && PROTECTED.has(base)) {
    parts.push(`⚠ branched from ${base} — feature branches should start from develop`);
  }
  return parts.join(' ');
}

// The base with the most recent merge-base commit is the closest ancestor branch.
function detectBase(branch) {
  let best = null;
  let bestTime = -1;
  for (const cand of BASE_CANDIDATES) {
    if (cand === branch) continue;
    for (const ref of [`origin/${cand}`, cand]) {
      const mb = git(`merge-base HEAD ${ref}`);
      if (!mb) continue;
      const t = Number(git(`show -s --format=%ct ${mb}`)) || 0;
      if (t > bestTime) {
        bestTime = t;
        best = cand;
      }
      break;
    }
  }
  return best;
}

export function staleManifests() {
  const stale = [];
  for (const manifest of walk(MANIFEST_DIR)) {
    if (!manifest.endsWith('.manifest.generated.json')) continue;
    let data;
    try {
      data = JSON.parse(readFileSync(manifest, 'utf8'));
    } catch {
      continue;
    }
    const manifestMtime = statSync(manifest).mtimeMs;
    const sources = collectSources(data);
    const isStale = sources.some((src) => {
      if (!existsSync(src)) return false;
      return statSync(src).mtimeMs - manifestMtime > TOLERANCE_MS;
    });
    if (isStale) stale.push(data.feature || manifest);
  }
  return stale;
}

function collectSources(data) {
  const out = [];
  for (const key of SOURCE_KEYS) {
    const arr = data[key];
    if (Array.isArray(arr)) {
      for (const v of arr) if (typeof v === 'string') out.push(v);
    }
  }
  return out;
}

// Changed .dart sources with @riverpod/@freezed whose generated partner is not
// also changed → build_runner has not been run for them yet.
function pendingCodegen() {
  const status = git('status --porcelain');
  if (!status) return [];

  const changed = new Set();
  for (const line of status.split('\n')) {
    const p = line.slice(3).trim();
    if (p) changed.add(p.replace(/^"|"$/g, ''));
  }

  const pending = [];
  for (const path of changed) {
    if (!path.endsWith('.dart')) continue;
    if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) continue;
    if (!existsSync(path)) continue;

    let content;
    try {
      content = readFileSync(path, 'utf8');
    } catch {
      continue;
    }

    const base = path.replace(/\.dart$/, '');
    const needsRiverpod = /@riverpod\b/i.test(content);
    const needsFreezed = /@freezed\b/.test(content);

    if (needsRiverpod && !changed.has(`${base}.g.dart`)) {
      pending.push(path);
      continue;
    }
    if (needsFreezed && !changed.has(`${base}.freezed.dart`)) {
      pending.push(path);
    }
  }
  return pending;
}

function* walk(dir) {
  let entries;
  try {
    entries = readdirSync(dir, { withFileTypes: true });
  } catch {
    return;
  }
  for (const e of entries) {
    const full = join(dir, e.name);
    if (e.isDirectory()) yield* walk(full);
    else yield full;
  }
}

function git(args) {
  try {
    return execSync(`git ${args}`, {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
      timeout: 1500,
    }).trim();
  } catch {
    return '';
  }
}
