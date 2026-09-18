import { spawnSync } from 'node:child_process';
import { isAbsolute, join, relative, resolve } from 'node:path';
import { readFileSync } from 'node:fs';
import { pathToFileURL } from 'node:url';

const DEFAULT_BASELINE = 'scripts/ci/flutter_analyze_baseline.json';
const MACHINE_SEVERITIES = new Set(['ERROR', 'WARNING', 'INFO']);

function repositoryPath(file, root) {
  const normalized = file.replaceAll('\\', '/');
  const path = isAbsolute(normalized)
    ? relative(root, normalized).replaceAll('\\', '/')
    : normalized.replace(/^\.\/+/, '');
  if (!path || path === '..' || path.startsWith('../') || isAbsolute(path)) {
    throw new Error(`analyzer path is outside the repository: ${file}`);
  }
  return path;
}

export function parseMachineDiagnostics(output, { root = process.cwd() } = {}) {
  const repositoryRoot = resolve(root);
  const diagnostics = [];
  const unexpected = [];

  for (const line of output.split(/\r?\n/)) {
    if (!line.trim()) continue;
    const fields = line.split('|');
    if (fields.length < 8 || !MACHINE_SEVERITIES.has(fields[0])) {
      unexpected.push(line);
      continue;
    }
    diagnostics.push({
      severity: fields[0],
      type: fields[1],
      code: fields[2],
      path: repositoryPath(fields[3], repositoryRoot),
    });
  }

  if (unexpected.length > 0) {
    throw new Error(
      `analyzer produced ${unexpected.length} non-machine line(s): ${unexpected[0]}`,
    );
  }
  return diagnostics;
}

function diagnosticKey({ severity, code, path }) {
  return `${severity}\u0000${code}\u0000${path}`;
}

function countsFor(diagnostics) {
  const counts = new Map();
  for (const diagnostic of diagnostics) {
    const key = diagnosticKey(diagnostic);
    counts.set(key, (counts.get(key) ?? 0) + 1);
  }
  return counts;
}

export function validateBaseline(baseline) {
  if (baseline?.schemaVersion !== 1 || !Array.isArray(baseline.diagnostics)) {
    throw new Error('analyzer baseline must use schemaVersion 1');
  }

  const seen = new Set();
  let total = 0;
  for (const entry of baseline.diagnostics) {
    if (
      !MACHINE_SEVERITIES.has(entry.severity) ||
      typeof entry.code !== 'string' ||
      !entry.code ||
      typeof entry.path !== 'string' ||
      !entry.path ||
      entry.path.startsWith('/') ||
      entry.path.startsWith('../') ||
      entry.path.split('/').includes('..') ||
      entry.path.includes('\\') ||
      !Number.isInteger(entry.count) ||
      entry.count < 1
    ) {
      throw new Error('analyzer baseline contains an invalid diagnostic entry');
    }
    const key = diagnosticKey(entry);
    if (seen.has(key)) {
      throw new Error(
        `analyzer baseline contains a duplicate entry: ${entry.severity} ${entry.code} ${entry.path}`,
      );
    }
    seen.add(key);
    total += entry.count;
  }

  if (baseline.total !== total) {
    throw new Error(
      `analyzer baseline total is ${baseline.total}; entries sum to ${total}`,
    );
  }
  return baseline;
}

export function compareWithBaseline(diagnostics, baseline) {
  validateBaseline(baseline);
  const current = countsFor(diagnostics);
  const allowed = new Map(
    baseline.diagnostics.map(entry => [diagnosticKey(entry), entry.count]),
  );
  const excess = [];

  for (const [key, count] of current) {
    const permitted = allowed.get(key) ?? 0;
    if (count <= permitted) continue;
    const [severity, code, path] = key.split('\u0000');
    excess.push({
      severity,
      code,
      path,
      current: count,
      baseline: permitted,
      excess: count - permitted,
    });
  }
  excess.sort((left, right) =>
    `${left.path}\u0000${left.severity}\u0000${left.code}`.localeCompare(
      `${right.path}\u0000${right.severity}\u0000${right.code}`,
    ),
  );

  const currentCount = diagnostics.length;
  const baselineCount = baseline.total;
  const newCount = excess.reduce((sum, entry) => sum + entry.excess, 0);
  const removedCount = baseline.diagnostics.reduce((sum, entry) => {
    const count = current.get(diagnosticKey(entry)) ?? 0;
    return sum + Math.max(0, entry.count - count);
  }, 0);
  return {
    ok: newCount === 0,
    currentCount,
    baselineCount,
    newCount,
    removedCount,
    excess,
  };
}

function validateAnalyzerExit(code, diagnostics, label, allowed) {
  if (!Number.isInteger(code) || !allowed.has(code)) {
    throw new Error(`${label} exited with unsupported status ${code}`);
  }
  if (code !== 0 && diagnostics.length === 0) {
    throw new Error(`${label} exited ${code} without machine diagnostics`);
  }
}

export function checkAnalyzerOutput({
  output,
  baseline,
  root = process.cwd(),
  analyzerExitCode = 0,
  flutterExitCode,
}) {
  const diagnostics = parseMachineDiagnostics(output, { root });
  validateAnalyzerExit(
    analyzerExitCode,
    diagnostics,
    'dart analyze --format machine',
    new Set([0, 1, 2, 3]),
  );
  if (flutterExitCode !== undefined) {
    validateAnalyzerExit(
      flutterExitCode,
      diagnostics,
      'flutter analyze',
      new Set([0, 1]),
    );
  }
  return compareWithBaseline(diagnostics, baseline);
}

export function formatResult(result) {
  const summary =
    `flutter analyze baseline: current=${result.currentCount} ` +
    `baseline=${result.baselineCount} new=${result.newCount} ` +
    `removed=${result.removedCount}`;
  if (result.ok) return summary;
  return [
    summary,
    ...result.excess.map(
      entry =>
        `${entry.path}  ${entry.severity} ${entry.code}: ` +
        `${entry.current} current, ${entry.baseline} baseline`,
    ),
  ].join('\n');
}

function parseArguments(argv) {
  const options = {
    run: false,
    root: process.cwd(),
    baseline: DEFAULT_BASELINE,
    input: null,
    analyzerExitCode: undefined,
    flutterExitCode: undefined,
  };
  for (const argument of argv) {
    if (argument === '--run') options.run = true;
    else if (argument.startsWith('--root=')) options.root = argument.slice(7);
    else if (argument.startsWith('--baseline=')) {
      options.baseline = argument.slice(11);
    } else if (argument.startsWith('--analyzer-exit-code=')) {
      options.analyzerExitCode = Number(argument.slice(21));
    } else if (argument.startsWith('--flutter-exit-code=')) {
      options.flutterExitCode = Number(argument.slice(20));
    } else if (!argument.startsWith('-') && options.input === null) {
      options.input = argument;
    } else {
      throw new Error(`unknown argument: ${argument}`);
    }
  }
  if (options.run === (options.input !== null)) {
    throw new Error('use exactly one of --run or a machine-output file');
  }
  return options;
}

export function main(argv = process.argv.slice(2)) {
  try {
    const options = parseArguments(argv);
    const root = resolve(options.root);
    const baselinePath = isAbsolute(options.baseline)
      ? options.baseline
      : join(root, options.baseline);
    const baseline = JSON.parse(readFileSync(baselinePath, 'utf8'));

    let output;
    let analyzerExitCode = options.analyzerExitCode;
    if (options.run) {
      const analyzer = spawnSync('dart', ['analyze', '--format', 'machine'], {
        cwd: root,
        encoding: 'utf8',
        maxBuffer: 32 * 1024 * 1024,
      });
      if (analyzer.error) throw analyzer.error;
      process.stdout.write(analyzer.stdout);
      process.stderr.write(analyzer.stderr);
      if (analyzer.stderr.trim()) {
        throw new Error('dart analyze --format machine wrote unexpected stderr');
      }
      output = analyzer.stdout;
      analyzerExitCode = analyzer.status;
    } else {
      const inputPath = isAbsolute(options.input)
        ? options.input
        : join(root, options.input);
      output = readFileSync(inputPath, 'utf8');
      analyzerExitCode ??= 0;
    }

    const result = checkAnalyzerOutput({
      output,
      baseline,
      root,
      analyzerExitCode,
      flutterExitCode: options.flutterExitCode,
    });
    const formatted = formatResult(result);
    (result.ok ? console.log : console.error)(formatted);
    return result.ok ? 0 : 1;
  } catch (error) {
    console.error(`flutter analyze baseline: ${error.message}`);
    return 1;
  }
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? '').href) {
  process.exitCode = main();
}
