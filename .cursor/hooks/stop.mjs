#!/usr/bin/env node
// Cursor Stop adapter. The result is persisted for inspection and never submits
// a follow-up message or blocks the stop.

import {
  readStdin,
  runIntegrityCheck,
  writeStatus,
} from '../../scripts/ai/integrity_check.mjs';

await readStdin(); // drain stdin; the check needs no fields from the payload

const result = await runIntegrityCheck();
writeStatus('.cursor/last-session-status.json', result);

process.exit(0);
