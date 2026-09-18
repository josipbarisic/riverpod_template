import assert from 'node:assert/strict';
import { mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';

import {
  checkAnalyzerOutput,
  compareWithBaseline,
  formatResult,
  parseMachineDiagnostics,
  validateBaseline,
} from './check_flutter_analyze_baseline.mjs';

const baseline = {
  schemaVersion: 1,
  total: 3,
  diagnostics: [
    {
      severity: 'WARNING',
      code: 'UNUSED_IMPORT',
      path: 'test/example_test.dart',
      count: 2,
    },
    {
      severity: 'INFO',
      code: 'AVOID_PRINT',
      path: 'lib/example.dart',
      count: 1,
    },
  ],
};

function machineLine(root, { severity, code, path }) {
  return [
    severity,
    severity === 'WARNING' ? 'STATIC_WARNING' : 'LINT',
    code,
    join(root, path),
    '1',
    '1',
    '1',
    'message',
  ].join('|');
}

function outputFor(root, diagnostics) {
  return `${diagnostics.map(diagnostic => machineLine(root, diagnostic)).join('\n')}\n`;
}

function withRoot(run) {
  const root = mkdtempSync(join(tmpdir(), 'analyzer-baseline-'));
  try {
    return run(root);
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
}

const currentDiagnostics = [
  {
    severity: 'WARNING',
    code: 'UNUSED_IMPORT',
    path: 'test/example_test.dart',
  },
  {
    severity: 'WARNING',
    code: 'UNUSED_IMPORT',
    path: 'test/example_test.dart',
  },
  {
    severity: 'INFO',
    code: 'AVOID_PRINT',
    path: 'lib/example.dart',
  },
];

test('machine diagnostics are normalized to repository-relative identities', () => {
  withRoot(root => {
    const parsed = parseMachineDiagnostics(
      outputFor(root, currentDiagnostics),
      { root },
    );
    assert.deepEqual(parsed[0], {
      severity: 'WARNING',
      type: 'STATIC_WARNING',
      code: 'UNUSED_IMPORT',
      path: 'test/example_test.dart',
    });
  });
});

test('the committed baseline passes at the exact current counts', () => {
  const result = compareWithBaseline(currentDiagnostics, baseline);
  assert.deepEqual(result, {
    ok: true,
    currentCount: 3,
    baselineCount: 3,
    newCount: 0,
    removedCount: 0,
    excess: [],
  });
  assert.equal(
    formatResult(result),
    'flutter analyze baseline: current=3 baseline=3 new=0 removed=0',
  );
});

test('removed diagnostics pass without changing the baseline', () => {
  const result = compareWithBaseline(currentDiagnostics.slice(0, 1), baseline);
  assert.equal(result.ok, true);
  assert.equal(result.currentCount, 1);
  assert.equal(result.baselineCount, 3);
  assert.equal(result.newCount, 0);
  assert.equal(result.removedCount, 2);
});

test('an excess occurrence of a baselined diagnostic fails', () => {
  const result = compareWithBaseline(
    [...currentDiagnostics, currentDiagnostics[0]],
    baseline,
  );
  assert.equal(result.ok, false);
  assert.equal(result.currentCount, 4);
  assert.equal(result.newCount, 1);
  assert.deepEqual(result.excess[0], {
    severity: 'WARNING',
    code: 'UNUSED_IMPORT',
    path: 'test/example_test.dart',
    current: 3,
    baseline: 2,
    excess: 1,
  });
});

test('a new severity, lint code, or repository path fails independently', () => {
  const additions = [
    {
      severity: 'ERROR',
      code: 'UNUSED_IMPORT',
      path: 'test/example_test.dart',
    },
    {
      severity: 'INFO',
      code: 'DEPRECATED_MEMBER_USE',
      path: 'lib/example.dart',
    },
    {
      severity: 'INFO',
      code: 'AVOID_PRINT',
      path: 'lib/other.dart',
    },
  ];
  const result = compareWithBaseline(
    [...currentDiagnostics, ...additions],
    baseline,
  );
  assert.equal(result.ok, false);
  assert.equal(result.newCount, 3);
  assert.equal(result.excess.length, 3);
});

test('removed and new counts are independent when one diagnostic replaces another', () => {
  const replacement = {
    severity: 'INFO',
    code: 'AVOID_PRINT',
    path: 'lib/other.dart',
  };
  const result = compareWithBaseline(
    [currentDiagnostics[0], currentDiagnostics[2], replacement],
    baseline,
  );
  assert.equal(result.currentCount, 3);
  assert.equal(result.baselineCount, 3);
  assert.equal(result.newCount, 1);
  assert.equal(result.removedCount, 1);
});

test('baseline schema rejects duplicate keys and an incorrect total', () => {
  assert.throws(
    () =>
      validateBaseline({
        ...baseline,
        diagnostics: [...baseline.diagnostics, baseline.diagnostics[0]],
      }),
    /duplicate entry/,
  );
  assert.throws(
    () => validateBaseline({ ...baseline, total: 4 }),
    /entries sum to 3/,
  );
});

test('non-machine output and analyzer infrastructure failures fail closed', () => {
  assert.throws(
    () => parseMachineDiagnostics('Analyzing project...\n'),
    /non-machine line/,
  );
  withRoot(root => {
    const output = outputFor(root, currentDiagnostics);
    assert.doesNotThrow(() =>
      checkAnalyzerOutput({
        output,
        baseline,
        root,
        analyzerExitCode: 2,
        flutterExitCode: 1,
      }),
    );
    assert.throws(
      () =>
        checkAnalyzerOutput({
          output,
          baseline,
          root,
          analyzerExitCode: 64,
          flutterExitCode: 1,
        }),
      /unsupported status 64/,
    );
    assert.throws(
      () =>
        checkAnalyzerOutput({
          output: '',
          baseline: { schemaVersion: 1, total: 0, diagnostics: [] },
          root,
          analyzerExitCode: 2,
        }),
      /without machine diagnostics/,
    );
  });
});
