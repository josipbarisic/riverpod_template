// Shared Stop-time policy behind the Claude Code Stop hook. It is advisory and local:
// the hook may surface or persist the result, but never forces another turn.

import { execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { pathToFileURL } from 'node:url';
import {
  BUILD_RUNNER_COMMAND,
  MANIFEST_COMMAND,
  changedFiles,
  pendingCodegen,
  staleManifests,
} from './session_status.mjs';

const INSTRUCTION_FILE =
  /^(?:AGENTS\.md|CLAUDE\.md|ARCHITECTURE\.md|README\.md|lib\/AGENTS\.md|docs\/.+\.md|\.claude\/(?:rules|skills|agents)\/.+\.md|\.github\/workflows\/.+\.ya?ml)$/;
const INSTRUCTION_VALIDATOR = 'scripts/ci/check_instruction_claims.mjs';
export const STATUS_FILE = '.claude/last-session-status.json';

/**
 * The repository's top-level directory, or `cwd` outside a repository. A session started in a
 * subfolder such as `android/` still checks and records the whole repository from its root.
 * @param {string} [cwd]
 */
export function repositoryRoot(cwd = process.cwd()) {
  try {
    return execFileSync('git', ['rev-parse', '--show-toplevel'], {
      cwd,
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    }).trim();
  } catch {
    return cwd;
  }
}

export function isInstructionFile(path) {
  return INSTRUCTION_FILE.test(path);
}

/**
 * Run the complete Stop-time integrity check.
 * The instruction-claim extension is loaded only when the later CI validator exists.
 * @param {{cwd?:string}} [options]
 * @returns {Promise<{ok:boolean, codegen:string[], manifests:string[], claims:string[]}>}
 */
export async function runIntegrityCheck({ cwd = process.cwd() } = {}) {
  const changed = changedFiles({ cwd });
  const codegen = pendingCodegen(changed, { cwd });
  const manifests = staleManifests(changed, { cwd });
  const claims = await unresolvedClaims(changed, { cwd });
  return {
    ok: codegen.length === 0 && manifests.length === 0 && claims.length === 0,
    codegen,
    manifests,
    claims,
  };
}

/**
 * Validate changed instruction files when the optional CI implementation exists.
 * Absence, import failure, or validator failure is fail-open for the Claude Code hooks.
 * @param {Iterable<string>} [changed]
 * @param {{cwd?:string}} [options]
 */
export async function unresolvedClaims(changed, { cwd = process.cwd() } = {}) {
  const validatorPath = join(cwd, INSTRUCTION_VALIDATOR);
  if (!existsSync(validatorPath)) return [];

  const documents = [...(changed ?? changedFiles({ cwd }))]
    .filter(path => isInstructionFile(path) && existsSync(join(cwd, path)));
  if (documents.length === 0) return [];

  try {
    const validator = await import(pathToFileURL(validatorPath).href);
    if (
      typeof validator.buildIndex !== 'function' ||
      typeof validator.checkDocument !== 'function'
    ) {
      return [];
    }
    const index = validator.buildIndex(cwd);
    return documents
      .flatMap(path =>
        validator.checkDocument({
          path,
          text: readFileSync(join(cwd, path), 'utf8'),
          index,
        }),
      )
      .map(violation => `${violation.path}:${violation.line} ${violation.message}`);
  } catch {
    return [];
  }
}

/**
 * Human-readable pass/fail summary.
 * @param {{ok:boolean, codegen:string[], manifests:string[], claims?:string[]}} result
 * @returns {string}
 */
export function formatIntegritySummary(result) {
  if (result.ok) {
    return 'Integrity check: PASS — codegen, manifests, and instruction claims are current.';
  }

  const lines = ['Integrity check: ACTION NEEDED'];
  if (result.codegen.length > 0) {
    lines.push(
      `- ${result.codegen.length} source(s) changed since last build_runner — run: ` +
        BUILD_RUNNER_COMMAND,
    );
    for (const f of result.codegen.slice(0, 8)) lines.push(`    · ${f}`);
  }
  if (result.manifests.length > 0) {
    lines.push(
      `- ${result.manifests.length} manifest(s) may be stale — run: ` +
        MANIFEST_COMMAND,
    );
    lines.push(`    · ${result.manifests.join(', ')}`);
  }
  if (result.claims?.length > 0) {
    lines.push(
      `- ${result.claims.length} instruction claim(s) do not resolve against source — run: ` +
        `node ${INSTRUCTION_VALIDATOR}`,
    );
    for (const claim of result.claims.slice(0, 8)) lines.push(`    · ${claim}`);
  }
  return lines.join('\n');
}

/**
 * Persist the result as JSON for later inspection / tooling.
 * @param {string} file Target path, e.g. `join(repositoryRoot(), STATUS_FILE)`.
 * @param {{ok:boolean, codegen:string[], manifests:string[], claims?:string[]}} result
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
