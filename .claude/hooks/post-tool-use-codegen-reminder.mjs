#!/usr/bin/env node
// Claude PostToolUse adapter. Detection and debounce live in scripts/ai/.

import { extractFilePath } from '../../scripts/ai/generated_file_policy.mjs';
import {
  classifyCodegenEdit,
  readStdin,
  shouldRemind,
} from '../../scripts/ai/codegen_reminder.mjs';

const raw = await readStdin();
let payload;
try {
  payload = JSON.parse(raw || '{}');
} catch {
  process.exit(0);
}

const toolInput = payload.tool_input ?? {};
const filePath = extractFilePath(toolInput);
const content =
  typeof toolInput.content === 'string'
    ? toolInput.content
    : typeof toolInput.new_string === 'string'
      ? toolInput.new_string
      : undefined;
const verdict = classifyCodegenEdit(filePath, content);

if (verdict.remind && shouldRemind(payload.session_id)) {
  process.stdout.write(
    JSON.stringify({
      hookSpecificOutput: {
        hookEventName: 'PostToolUse',
        additionalContext: `Codegen reminder: ${verdict.reason}`,
      },
    }),
  );
}

process.exit(0);
