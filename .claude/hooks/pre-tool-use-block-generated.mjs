#!/usr/bin/env node
// Claude PreToolUse adapter. File classification lives in scripts/ai/.

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
  process.exit(0);
}

const verdict = classifyFile(extractFilePath(payload.tool_input));
if (verdict.action === 'block') {
  emit({
    hookSpecificOutput: {
      hookEventName: 'PreToolUse',
      permissionDecision: 'deny',
      permissionDecisionReason: `${verdict.title}\n\n${verdict.detail}`,
    },
  });
}

process.exit(0);

function emit(output) {
  process.stdout.write(JSON.stringify(output));
  process.exit(0);
}
