#!/usr/bin/env node
// Claude Stop adapter. The result is advisory and never blocks the stop.

import { join } from 'node:path';

import {
  STATUS_FILE,
  formatIntegritySummary,
  readStdin,
  repositoryRoot,
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

const root = repositoryRoot();
const result = await runIntegrityCheck({ cwd: root });
writeStatus(join(root, STATUS_FILE), result);
if (!result.ok) {
  process.stdout.write(
    JSON.stringify({ systemMessage: formatIntegritySummary(result) }),
  );
}

process.exit(0);
