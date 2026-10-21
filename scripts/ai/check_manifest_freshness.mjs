#!/usr/bin/env node
// Local manifest freshness gate: CI's Manifest Freshness Check, run on this checkout.
// It runs the generator, compares each manifest with the checked-out copy ignoring
// `generatedAt`, then restores every manifest exactly. On a clean branch that is
// CI's comparison against HEAD, so sources committed without regenerated manifests
// fail here instead of on the pull request. CI stays the final gate.
//
// Exit codes: 0 = manifests fresh, 1 = stale manifest(s) listed on stdout.

import { execFileSync } from 'node:child_process';
import { existsSync } from 'node:fs';

import { MANIFEST_COMMAND, staleManifests } from './session_status.mjs';

// Run through FVM only when this checkout pins an SDK with it.
const [executable, ...args] = existsSync('.fvmrc')
  ? ['fvm', ...MANIFEST_COMMAND.split(' ')]
  : MANIFEST_COMMAND.split(' ');
const command = [executable, ...args].join(' ');

const stale = staleManifests(undefined, {
  regenerate: () =>
    execFileSync(executable, args, {
      shell: process.platform === 'win32',
      stdio: ['ignore', 'ignore', 'inherit'],
    }),
});
if (stale.length > 0) {
  console.log('Feature manifests out of date with their sources:');
  for (const feature of stale) console.log(`  - ${feature}`);
  console.log(`Run: ${command}, then commit the manifests.`);
  process.exitCode = 1;
} else {
  console.log('Manifest freshness: PASS');
}
