// Shared policy for pre-tool-use file guards.
//
// Imported by the Cursor preToolUse hook (.cursor/hooks/). This module contains
// no tool-specific I/O — the hook adapts the verdict to its own JSON contract.
//
// Verdicts:
//   block  -> generated/derived file that must never be hand-edited
//   warn   -> editable, but the author must take a follow-up action
//   allow  -> no policy applies

/**
 * Classify a target file path.
 * @param {string|null|undefined} rawPath
 * @returns {{action:'block'|'warn'|'allow', title?:string, detail?:string, source?:string}}
 */
export function classifyFile(rawPath) {
  if (!rawPath || typeof rawPath !== 'string') return { action: 'allow' };

  const p = rawPath.replace(/\\/g, '/');
  const base = p.split('/').pop() || p;

  // build_runner / Freezed generated Dart — edit the annotated source instead.
  if (base.endsWith('.g.dart') || base.endsWith('.freezed.dart')) {
    const source = base.replace(/\.(g|freezed)\.dart$/, '.dart');
    return {
      action: 'block',
      title: 'Generated Dart file is read-only',
      source,
      detail:
        `${base} is produced by build_runner and must not be edited by hand.\n` +
        `Edit the source file "${source}" (its @riverpod / @freezed annotations), ` +
        `then regenerate with:\n` +
        `  dart run build_runner build -d`,
    };
  }

  // Generated feature manifests — regenerate from source instead.
  if (base.endsWith('.manifest.generated.json')) {
    return {
      action: 'block',
      title: 'Generated manifest is read-only',
      source: 'the underlying feature source files',
      detail:
        `${base} is generated and must not be edited by hand.\n` +
        `Change the underlying feature source, then regenerate with:\n` +
        `  dart run scripts/generate_feature_manifests.dart`,
    };
  }

  return { action: 'allow' };
}

/**
 * Best-effort extraction of a target file path from a hook payload's tool_input.
 * Field names differ slightly across tool schemas, so we check the known variants.
 * @param {unknown} toolInput
 * @returns {string|null}
 */
export function extractFilePath(toolInput) {
  if (!toolInput || typeof toolInput !== 'object') return null;
  const ti = /** @type {Record<string, unknown>} */ (toolInput);
  const candidate =
    ti.file_path ?? ti.path ?? ti.target_file ?? ti.target_notebook ?? null;
  return typeof candidate === 'string' ? candidate : null;
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
