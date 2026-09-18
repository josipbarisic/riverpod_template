#!/usr/bin/env node
// Claude SessionStart adapter. Plain stdout becomes session context.

import { buildSummary } from '../../scripts/ai/session_status.mjs';

try {
  process.stdout.write(buildSummary());
} catch {
  // Status is advisory; session startup must fail open.
}
process.exit(0);
