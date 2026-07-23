#!/usr/bin/env node
// Cursor sessionStart hook: inject a concise repo status summary
// (branch/base, manifest freshness, pending codegen) into the conversation's
// initial context. Fire-and-forget; output { additional_context }. Shared logic
// lives in scripts/ai/session_status.mjs. Registered in .cursor/hooks.json.

import { buildSummary } from '../../scripts/ai/session_status.mjs';

let summary = '';
try {
  summary = buildSummary();
} catch {
  // Never block or noisily fail a session on a status hook.
}
process.stdout.write(JSON.stringify({ additional_context: summary }));
process.exit(0);
