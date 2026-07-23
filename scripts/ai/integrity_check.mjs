// Session-Stop integrity check for the Cursor stop hook.
//
// Imported by .cursor/hooks/stop.mjs so the agent loop verifies two invariants
// when it ends:
//   1. Codegen integrity — a changed .dart source carrying @riverpod/@freezed
//      whose generated partner (.g.dart/.freezed.dart) is missing or older than
//      the source (build_runner has not been re-run since the edit).
//   2. Manifest freshness — a presentation source newer than its generated
//      manifest (reused from session_status to avoid drift).
//
// Everything is local (git + fs) and scoped to git-changed files so it stays
// fast enough to run on every agent stop. Non-blocking by design: the caller
// reports the result, it never forces the loop to continue.

import { execSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { dirname } from 'node:path';
import { staleManifests } from './session_status.mjs';

// mtime jitter tolerance (ms) so a git checkout that rewrites both files in the
// same instant doesn't get flagged as stale.
const TOLERANCE_MS = 2000;

/**
 * Run the full Stop-time integrity check.
 * @returns {{ok:boolean, codegen:string[], manifests:string[]}}
 */
export function runIntegrityCheck() {
  const codegen = staleCodegen();
  const manifests = staleManifests();
  return { ok: codegen.length === 0 && manifests.length === 0, codegen, manifests };
}

/**
 * Changed .dart sources whose generated partner is missing or older than the
 * source itself. This is the mtime-based counterpart to the git-set heuristic
 * in session_status: it catches an edited annotated file even when the stale
 * generated file was never touched.
 * @returns {string[]}
 */
function staleCodegen() {
  const changed = changedFiles();
  const stale = [];

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
    const srcMtime = statSync(path).mtimeMs;

    if (/@(riverpod|Riverpod)\b/.test(content) && isStalePartner(`${base}.g.dart`, srcMtime)) {
      stale.push(path);
      continue;
    }
    if (/@(freezed|Freezed)\b/.test(content) && isStalePartner(`${base}.freezed.dart`, srcMtime)) {
      stale.push(path);
    }
  }
  return stale;
}

// A partner is stale if it does not exist, or the source was modified more than
// TOLERANCE_MS after the partner was last generated.
function isStalePartner(partner, srcMtime) {
  if (!existsSync(partner)) return true;
  try {
    return srcMtime - statSync(partner).mtimeMs > TOLERANCE_MS;
  } catch {
    return true;
  }
}

function changedFiles() {
  const status = git('status --porcelain');
  if (!status) return [];
  const out = new Set();
  for (const line of status.split('\n')) {
    const p = line.slice(3).trim();
    if (p) out.add(p.replace(/^"|"$/g, ''));
  }
  return [...out];
}

/**
 * Human-readable pass/fail summary.
 * @param {{ok:boolean, codegen:string[], manifests:string[]}} result
 * @returns {string}
 */
export function formatIntegritySummary(result) {
  if (result.ok) return 'Integrity check: PASS — codegen and manifests are up to date.';

  const lines = ['Integrity check: ACTION NEEDED'];
  if (result.codegen.length > 0) {
    lines.push(
      `- ${result.codegen.length} source(s) changed since last build_runner — run: ` +
        'dart run build_runner build -d',
    );
    for (const f of result.codegen.slice(0, 8)) lines.push(`    · ${f}`);
  }
  if (result.manifests.length > 0) {
    lines.push(
      `- ${result.manifests.length} manifest(s) may be stale — run: ` +
        'dart run scripts/generate_feature_manifests.dart',
    );
    lines.push(`    · ${result.manifests.join(', ')}`);
  }
  return lines.join('\n');
}

/**
 * Persist the result as JSON for later inspection / tooling.
 * @param {string} file  Target path, e.g. `.cursor/last-session-status.json`.
 * @param {{ok:boolean, codegen:string[], manifests:string[]}} result
 */
export function writeStatus(file, result) {
  try {
    mkdirSync(dirname(file), { recursive: true });
    writeFileSync(
      file,
      JSON.stringify(
        { checkedAt: new Date().toISOString(), ...result },
        null,
        2,
      ),
    );
  } catch {
    // best-effort; a failed write must never break the stop flow
  }
}

/**
 * Read all of stdin as a string, resolving early if the stream never ends.
 * @returns {Promise<string>}
 */
export function readStdin() {
  return new Promise((resolve) => {
    let data = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => (data += chunk));
    process.stdin.on('end', () => resolve(data));
    setTimeout(() => resolve(data), 2000);
  });
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
