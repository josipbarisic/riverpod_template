#!/usr/bin/env node
// Cursor preToolUse hook: block hand-edits to generated files. Policy is shared
// via scripts/ai/generated_file_policy.mjs.
//
// Contract (Cursor): exit 0 and emit { permission, user_message, agent_message }
// on stdout. `permission: "deny"` blocks the tool call. Registered in
// .cursor/hooks.json for Write|StrReplace.

import {
  classifyFile,
  extractFilePath,
  readStdin,
} from '../../scripts/ai/generated_file_policy.mjs';

const raw = await readStdin();

let payload;
try {
  payload = JSON.parse(raw || '{}');
} catch {
  emit({ permission: 'allow' }); // fail-open on unparseable input
}

const verdict = classifyFile(extractFilePath(payload.tool_input));

if (verdict.action === 'block') {
  emit({
    permission: 'deny',
    user_message: verdict.title,
    agent_message: `${verdict.title}\n\n${verdict.detail}`,
  });
}

if (verdict.action === 'warn') {
  emit({
    permission: 'allow',
    agent_message: `${verdict.title}: ${verdict.detail}`,
  });
}

emit({ permission: 'allow' });

function emit(obj) {
  process.stdout.write(JSON.stringify(obj));
  process.exit(0);
}
