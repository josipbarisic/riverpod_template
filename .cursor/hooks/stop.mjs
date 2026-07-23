#!/usr/bin/env node
// Cursor stop hook: when the agent loop ends, verify codegen and manifest
// integrity. Detection is shared via scripts/ai/integrity_check.mjs. Complements
// the sessionStart status report.
//
// Contract (Cursor): the stop hook may return { followup_message } to auto-submit
// a next user message. That is intrusive (it drives another agent turn), so by
// default this hook is NON-BLOCKING: it only writes the pass/fail result to
// .cursor/last-session-status.json. Set STOP_AUTOFIX=1 to opt into an auto
// follow-up nudge when the check fails. Registered under stop.

import {
  formatIntegritySummary,
  readStdin,
  runIntegrityCheck,
  writeStatus,
} from '../../scripts/ai/integrity_check.mjs';

await readStdin(); // drain stdin; the check needs no fields from the payload

const result = runIntegrityCheck();
writeStatus('.cursor/last-session-status.json', result);

if (!result.ok && process.env.STOP_AUTOFIX === '1') {
  process.stdout.write(
    JSON.stringify({ followup_message: formatIntegritySummary(result) }),
  );
}

process.exit(0);
