#!/usr/bin/env node
// Read-only local gate over the same changed-file policy used by session hooks.
// It never invokes the generator or writes manifest files.

import { MANIFEST_COMMAND, staleManifests } from './session_status.mjs';

const stale = staleManifests();
if (stale.length > 0) {
  console.log('Feature manifests needing verification after local source changes:');
  for (const feature of stale) console.log(`  - ${feature}`);
  console.log(`Run: ${MANIFEST_COMMAND}`);
  process.exitCode = 1;
} else {
  console.log('Manifest freshness: PASS');
}
