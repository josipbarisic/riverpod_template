#!/usr/bin/env node
// Claude Stop adapter. The result is advisory and never blocks the stop.

import {
  formatIntegritySummary,
  readStdin,
  runIntegrityCheck,
  writeStatus,
} from '../../scripts/ai/integrity_check.mjs';

const raw = await readStdin();
let payload = {};
try {
  payload = JSON.parse(raw || '{}');
} catch {
  process.exit(0);
}
if (payload.stop_hook_active) process.exit(0);

const result = await runIntegrityCheck();
writeStatus('.claude/last-session-status.json', result);
if (!result.ok) {
  process.stdout.write(
    JSON.stringify({ systemMessage: formatIntegritySummary(result) }),
  );
}

process.exit(0);
