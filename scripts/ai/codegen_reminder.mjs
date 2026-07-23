// Shared codegen-reminder policy for the post-tool-use hook.
//
// Imported by the Cursor postToolUse hook (.cursor/hooks/). This module owns
// annotation detection and the per-session debounce; the hook only adapts the
// result to its own JSON contract.
//
// Rationale: editing a file that carries @riverpod / @freezed (or another
// build_runner) annotation without regenerating produces confusing runtime
// errors. After such an edit we nudge the author to run build_runner.

import { readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

// Annotations that require a build_runner pass. Matches both the lowercase
// convenience form (@riverpod, @freezed) and the configurable class form
// (@Riverpod(...), @Freezed(...)), plus json_serializable.
const CODEGEN_ANNOTATION =
  /@(riverpod|Riverpod|freezed|Freezed|JsonSerializable|json_serializable)\b/;

// Suppress repeat reminders within the same session for this long. Multiple
// annotated edits in a short burst should nudge once, not on every keystroke.
const DEBOUNCE_MS = 3 * 60 * 1000;

export const BUILD_RUNNER_COMMAND = 'dart run build_runner build -d';

/**
 * Decide whether an edited file warrants a build_runner reminder.
 *
 * @param {string|null|undefined} rawPath  Target file path from the tool input.
 * @param {string|null|undefined} [content] Optional written content; when
 *   omitted (or empty) the file is read from disk as a fallback.
 * @returns {{remind:boolean, reason?:string}}
 */
export function classifyCodegenEdit(rawPath, content) {
  if (!rawPath || typeof rawPath !== 'string') return { remind: false };

  const p = rawPath.replace(/\\/g, '/');
  const base = p.split('/').pop() || p;

  // Only Dart sources qualify. Generated outputs are read-only (blocked by the
  // PreToolUse guard) and must never trigger a reminder about themselves.
  if (!base.endsWith('.dart')) return { remind: false };
  if (base.endsWith('.g.dart') || base.endsWith('.freezed.dart')) {
    return { remind: false };
  }

  let text = typeof content === 'string' ? content : '';
  if (!text) {
    try {
      text = readFileSync(rawPath, 'utf8');
    } catch {
      return { remind: false }; // can't read → nothing to assert
    }
  }

  if (!CODEGEN_ANNOTATION.test(text)) return { remind: false };

  return {
    remind: true,
    reason:
      `${base} contains a build_runner annotation (@riverpod / @freezed / ` +
      `@JsonSerializable). Regenerate the derived files so the code compiles:\n` +
      `  ${BUILD_RUNNER_COMMAND}`,
  };
}

/**
 * Per-session debounce. Returns true at most once per DEBOUNCE_MS window for a
 * given session, writing a timestamp stamp file under the OS temp dir. Fails
 * open (returns true) if the stamp can't be read/written so a transient FS
 * error never silences the reminder entirely.
 *
 * @param {string|null|undefined} sessionId
 * @returns {boolean}
 */
export function shouldRemind(sessionId) {
  const stamp = stampPath(sessionId);
  const now = Date.now();
  try {
    const last = Number.parseInt(readFileSync(stamp, 'utf8'), 10);
    if (Number.isFinite(last) && now - last < DEBOUNCE_MS) return false;
  } catch {
    // no stamp yet (or unreadable) → treat as due
  }
  try {
    writeFileSync(stamp, String(now));
  } catch {
    // best-effort; still remind this time
  }
  return true;
}

function stampPath(sessionId) {
  const safe = String(sessionId || 'default').replace(/[^A-Za-z0-9_-]/g, '_');
  return join(tmpdir(), `riverpod-template-codegen-reminder-${safe}.stamp`);
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
