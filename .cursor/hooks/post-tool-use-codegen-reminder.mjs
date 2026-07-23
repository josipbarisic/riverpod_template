#!/usr/bin/env node
// Cursor postToolUse hook: after an edit to a Dart source that carries a
// build_runner annotation (@riverpod / @freezed / @JsonSerializable), remind the
// agent to regenerate. Detection + per-session debounce are shared via
// scripts/ai/codegen_reminder.mjs.
//
// Contract (Cursor): exit 0 and emit { additional_context } on stdout. Injected
// into the conversation after the tool result. Registered in .cursor/hooks.json
// for Write|StrReplace.

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
  process.exit(0); // fail-open on unparseable input
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

if (verdict.remind && shouldRemind(payload.session_id ?? payload.conversation_id)) {
  process.stdout.write(
    JSON.stringify({ additional_context: `Codegen reminder: ${verdict.reason}` }),
  );
}

process.exit(0);
