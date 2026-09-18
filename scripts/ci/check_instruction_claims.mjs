// Instruction files are operational inputs. This validator resolves their
// mechanically checkable claims against the repository instead of trusting
// copied paths, symbol names, command inventories, or retired layer names.
//
// Semantic claims still require source review: the existence of a class or
// command cannot prove that prose describes its behavior correctly.

import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, readdirSync, statSync } from 'node:fs';
import { join, relative, resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

const REPOSITORY_ROOTS = [
  'lib/',
  'test/',
  'scripts/',
  'docs/',
  'android/',
  'ios/',
  'linux/',
  'macos/',
  'web/',
  'windows/',
  '.github/',
  '.claude/',
  '.cursor/',
];

const ROOT_FILES = new Set([
  'AGENTS.md',
  'CLAUDE.md',
  'ARCHITECTURE.md',
  'README.md',
  'analysis_options.yaml',
  'pubspec.yaml',
  'pubspec.lock',
  '.env.example',
]);

const ARCHIVE_FILES = new Set([
  'docs/LEARNING_LOG.md',
  '.cursor/docs/LEARNING_LOG.md',
]);

const PLACEHOLDER_MEMBERS = new Set([
  'featureName',
  'member',
  'name',
  'routeName',
  'target',
  'value',
  'x',
]);

const NEGATIVE_EXAMPLE =
  /❌|\bBAD\b|\bWRONG\b|\bNever\b|\bdo not\b|\binvalid\b|\bfictional\b|\bstale\b|\blegacy\b|\breject(?:s|ed)?\b|\binstead of\b/i;

const PROSPECTIVE_PATH =
  /\b(?:creat(?:e|es|ed|ing)|emit(?:s|ted|ting)?|generat(?:e|es|ed|ing)|writ(?:e|es|ten|ing))\s+(?:a\s+|an\s+|the\s+)?`/i;

const STALE_LAYER_REFERENCES = [
  { pattern: /\blib\/domain(?:\/|\b)/g, replacement: '`lib/models/`' },
  { pattern: /\btest\/models(?:\/|\b)/g, replacement: '`test/domain/`' },
];

const PARITY_CLAIM =
  /what .*\bruns\b|CI (?:runs|executes)|the .*\bjob runs\b|the .*workflow runs\b|runs in CI|same (?:command )?as CI/i;

function normalizePathToken(value) {
  return value
    .trim()
    .replace(/^['"(]+|['"),.;:]+$/g, '')
    .replace(/^\.\/+/, '')
    .replace(/#L\d+(?:-L\d+)?$/, '')
    .replace(/\/+$/, '');
}

function isPlaceholderOrGlob(value) {
  return /[*{}<>$|[\]]/.test(value) || value.includes('...') || value.includes('://');
}

function looksLikeRepositoryPath(value, repoRoots = new Set()) {
  const token = normalizePathToken(value);
  if (!token || isPlaceholderOrGlob(token) || token.includes('..')) return false;
  if (!/^[\w@.+/-]+$/.test(token)) return false;
  if (ROOT_FILES.has(token) || /^[A-Z][A-Z0-9_-]+\.md$/.test(token)) return true;
  if (REPOSITORY_ROOTS.some(root => token.startsWith(root))) return true;
  const first = token.split('/')[0];
  return token.includes('/') && repoRoots.has(first);
}

/**
 * Resolve repository paths from Git-visible files. Tracked and untracked
 * non-ignored files are included so local checks work before staging; ignored
 * paths remain valid environment-local references even when absent in CI.
 */
export function pathResolver({ tracked, isIgnored }) {
  const files = new Set([...tracked].map(normalizePathToken));
  const directories = new Set();
  const repoRoots = new Set();

  for (const file of files) {
    const parts = file.split('/');
    if (parts.length > 1) repoRoots.add(parts[0]);
    for (let depth = 1; depth < parts.length; depth += 1) {
      directories.add(parts.slice(0, depth).join('/'));
    }
  }

  const pathExists = target => {
    const clean = normalizePathToken(target);
    return files.has(clean) || directories.has(clean) || isIgnored(clean);
  };
  pathExists.repoRoots = repoRoots;
  return pathExists;
}

export function stripFences(markdown) {
  const lines = markdown.split('\n');
  let inFence = false;
  return lines
    .map(line => {
      if (/^\s*```/.test(line)) {
        inFence = !inFence;
        return '';
      }
      return inFence ? '' : line;
    })
    .join('\n');
}

export function inlineCode(markdown) {
  const found = [];
  let inFence = false;
  markdown.split('\n').forEach((line, index) => {
    if (/^\s*```/.test(line)) {
      inFence = !inFence;
      return;
    }
    if (inFence) return;
    for (const match of line.matchAll(/`([^`\n]+)`/g)) {
      found.push({ value: match[1], line: index + 1 });
    }
  });
  return found;
}

export function fencedBlocks(markdown) {
  const lines = markdown.split('\n');
  const blocks = [];
  let open = null;
  lines.forEach((line, index) => {
    const fence = /^\s*```([\w-]*)/.exec(line);
    if (!fence) return;
    if (open) {
      blocks.push({ ...open, code: lines.slice(open.line, index).join('\n') });
      open = null;
      return;
    }
    open = {
      lang: fence[1],
      line: index + 1,
      leadIn: lines.slice(Math.max(0, index - 4), index).join('\n'),
    };
  });
  return blocks;
}

function shellTokens(command) {
  return command
    .replace(/\\\s*\n\s*/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .split(' ')
    .map(token => token.replace(/^['"]|['",;]$/g, ''))
    .filter(Boolean);
}

export function commandShape(command) {
  const tokens = shellTokens(command);
  while (/^[A-Za-z_][A-Za-z0-9_]*=/.test(tokens[0] ?? '')) tokens.shift();
  if (tokens[0] === 'fvm') tokens.shift();

  const runner = tokens.shift();
  if (!['dart', 'flutter', 'node'].includes(runner)) return null;

  let action = tokens.shift() ?? '';
  let subject = null;
  if (runner === 'node' && action !== '--test') {
    subject = action;
    action = 'execute';
  } else if (runner === 'dart' && action === 'run') {
    subject = tokens[0] ?? null;
  }

  const flags = tokens
    .filter(token => /^--?[\w-]+/.test(token))
    .map(token => token.split('=')[0])
    .sort();
  const paths = [subject, ...tokens]
    .filter(Boolean)
    .map(normalizePathToken)
    .filter((token, index, all) =>
      looksLikeRepositoryPath(token) && all.indexOf(token) === index,
    )
    .sort();

  return { runner, action, subject, paths, flags };
}

function commandKey(shape) {
  return JSON.stringify({
    runner: shape.runner,
    action: shape.action,
    subject: shape.subject,
    paths: shape.paths,
    flags: shape.flags,
  });
}

export function claimsCiParity(text) {
  return PARITY_CLAIM.test(text);
}

function shellCommands(code) {
  return code
    .replace(/\\\s*\n\s*/g, ' ')
    .split('\n')
    .map(line => line.replace(/\s+#.*$/, '').trim())
    .filter(Boolean);
}

function workflowRunBlocks(text) {
  const lines = text.split('\n');
  const commands = [];

  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index];
    const inline = /^\s*(?:-\s*)?run:\s+(?![|>])(.+)$/.exec(line);
    if (inline) {
      commands.push(inline[1].trim());
      continue;
    }

    const block = /^(\s*)(?:-\s*)?run:\s*([|>])[-+]?\s*$/.exec(line);
    if (!block) continue;
    const indentation = block[1].length;
    const body = [];
    let cursor = index + 1;
    for (; cursor < lines.length; cursor += 1) {
      const next = lines[cursor];
      if (!next.trim()) {
        body.push('');
        continue;
      }
      const nextIndentation = /^\s*/.exec(next)[0].length;
      if (nextIndentation <= indentation) break;
      body.push(next.slice(indentation + 2));
    }
    index = cursor - 1;
    commands.push(...(block[2] === '>' ? [body.join(' ')] : shellCommands(body.join('\n'))));
  }

  return commands;
}

function findMatchingBrace(text, open) {
  let depth = 0;
  let quote = null;
  let escaped = false;
  for (let index = open; index < text.length; index += 1) {
    const character = text[index];
    if (quote) {
      if (escaped) escaped = false;
      else if (character === '\\') escaped = true;
      else if (character === quote) quote = null;
      continue;
    }
    if (character === "'" || character === '"') {
      quote = character;
      continue;
    }
    if (character === '{') depth += 1;
    if (character === '}') {
      depth -= 1;
      if (depth === 0) return index;
    }
  }
  return -1;
}

function nestingDepthAt(text, target) {
  let depth = 0;
  let quote = null;
  let escaped = false;
  for (let index = 0; index < target; index += 1) {
    const character = text[index];
    if (quote) {
      if (escaped) escaped = false;
      else if (character === '\\') escaped = true;
      else if (character === quote) quote = null;
      continue;
    }
    if (character === "'" || character === '"') {
      quote = character;
      continue;
    }
    if (character === '{') depth += 1;
    if (character === '}') depth -= 1;
  }
  return depth;
}

function appClassesFrom(text) {
  const classes = [];
  for (const match of text.matchAll(
    /(?:abstract\s+)?(?:final\s+|sealed\s+|base\s+)*class\s+(App[A-Z]\w*)\b/g,
  )) {
    const open = text.indexOf('{', match.index);
    if (open < 0) continue;
    const close = findMatchingBrace(text, open);
    if (close < 0) continue;
    const body = text.slice(open + 1, close);
    const members = new Set();

    for (const declaration of body.matchAll(
      /^\s*(?:static\s+)?(?:late\s+)?(?:(?:const|final)\s+)?[\w<>,?.]+\s+(\w+)\s*(?:=|;)/gm,
    )) {
      if (nestingDepthAt(body, declaration.index) === 0) {
        members.add(declaration[1]);
      }
    }
    for (const declaration of body.matchAll(
      /^\s*(?:static\s+)?[\w<>,?.]+\s+get\s+(\w+)\s*(?:=>|;|\{)/gm,
    )) {
      if (nestingDepthAt(body, declaration.index) === 0) {
        members.add(declaration[1]);
      }
    }
    for (const declaration of body.matchAll(
      /^\s*(?:static\s+)?[\w<>,?.]+\s+(\w+)\s*\(/gm,
    )) {
      if (nestingDepthAt(body, declaration.index) === 0) {
        members.add(declaration[1]);
      }
    }
    classes.push([match[1], members]);
  }
  return classes;
}

function walk(directory, out = []) {
  if (!existsSync(directory)) return out;
  for (const entry of readdirSync(directory)) {
    const full = join(directory, entry);
    const stat = statSync(full);
    if (stat.isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

function isArchived(path) {
  return ARCHIVE_FILES.has(path) ||
    path.startsWith('.claude/runtime/') ||
    path.startsWith('.cursor/runtime/');
}

export function checkDocument({ path, text, index }) {
  const violations = [];
  const add = (line, message) => violations.push({ path, line, message });
  if (isArchived(path)) return violations;

  const lines = text.split('\n');
  const repoRoots = index.pathExists.repoRoots ?? index.repoRoots ?? new Set();
  const checkCommandPaths = (shape, line) => {
    for (const target of shape.paths) {
      if (!index.pathExists(target)) {
        add(line, `runs \`${target}\`, which this repository does not have`);
      }
    }
  };

  for (const { value, line } of inlineCode(text)) {
    const command = commandShape(value);
    if (command) {
      checkCommandPaths(command, line);
      continue;
    }
    const token = normalizePathToken(value);
    if (NEGATIVE_EXAMPLE.test(lines[line - 1] ?? '')) continue;
    if (PROSPECTIVE_PATH.test(lines[line - 1] ?? '')) continue;
    if (!looksLikeRepositoryPath(token, repoRoots)) continue;
    if (!index.pathExists(token)) {
      add(line, `references \`${token}\`, which this repository does not have`);
    }
  }

  for (const match of text.matchAll(/\b(App[A-Z]\w*)\.(\w+)/g)) {
    const [, className, member] = match;
    const line = text.slice(0, match.index).split('\n').length;
    if (PLACEHOLDER_MEMBERS.has(member)) continue;
    if (NEGATIVE_EXAMPLE.test(lines[line - 1] ?? '')) continue;
    const members = index.appClasses.get(className);
    if (!members) {
      add(line, `cites \`${className}\`, which no class in lib/ declares`);
    } else if (members.size > 0 && !members.has(member)) {
      add(
        line,
        `cites \`${className}.${member}\`, which \`${className}\` does not declare`,
      );
    }
  }

  if (/^\.github\/workflows\/.+\.ya?ml$/.test(path)) {
    for (const command of workflowRunBlocks(text)) {
      const shape = commandShape(command);
      if (!shape) continue;
      const offset = text.indexOf(command);
      const line = offset < 0 ? 1 : text.slice(0, offset).split('\n').length;
      checkCommandPaths(shape, line);
    }
  }

  for (const block of fencedBlocks(text)) {
    if (!['bash', 'sh', 'shell'].includes(block.lang)) continue;
    for (const command of shellCommands(block.code)) {
      const shape = commandShape(command);
      if (!shape) continue;
      checkCommandPaths(shape, block.line);
      if (!claimsCiParity(block.leadIn)) continue;
      if (!index.workflowCommandKeys.has(commandKey(shape))) {
        add(
          block.line,
          `claims parity with CI, but no workflow runs the same command shape: \`${command}\``,
        );
      }
    }
  }

  const prose = stripFences(text);
  for (const { pattern, replacement } of STALE_LAYER_REFERENCES) {
    for (const match of prose.matchAll(pattern)) {
      const line = prose.slice(0, match.index).split('\n').length;
      if (NEGATIVE_EXAMPLE.test(lines[line - 1] ?? '')) continue;
      add(
        line,
        `uses stale layer path \`${normalizePathToken(match[0])}\`; use ${replacement}`,
      );
    }
  }

  return violations;
}

export function buildIndex(root = '.') {
  const repositoryRoot = resolve(root);
  const dartFiles = walk(join(repositoryRoot, 'lib'))
    .filter(file => file.endsWith('.dart'))
    .filter(file => !file.endsWith('.g.dart') && !file.endsWith('.freezed.dart'));
  const appClasses = new Map();
  for (const file of dartFiles) {
    for (const [name, members] of appClassesFrom(readFileSync(file, 'utf8'))) {
      const collected = appClasses.get(name) ?? new Set();
      for (const member of members) collected.add(member);
      appClasses.set(name, collected);
    }
  }

  const workflowCommands = [];
  for (const file of walk(join(repositoryRoot, '.github/workflows'))) {
    if (!/\.ya?ml$/.test(file)) continue;
    for (const command of workflowRunBlocks(readFileSync(file, 'utf8'))) {
      const shape = commandShape(command);
      if (shape) workflowCommands.push(shape);
    }
  }

  const visible = new Set(
    execFileSync(
      'git',
      ['ls-files', '--cached', '--others', '--exclude-standard'],
      {
        cwd: repositoryRoot,
        encoding: 'utf8',
        maxBuffer: 32 * 1024 * 1024,
      },
    ).split('\n').filter(Boolean),
  );
  const isIgnored = target => {
    try {
      execFileSync('git', ['check-ignore', '-q', '--', target], {
        cwd: repositoryRoot,
        stdio: 'ignore',
      });
      return true;
    } catch {
      return false;
    }
  };
  const pathExists = pathResolver({ tracked: visible, isIgnored });

  return {
    appClasses,
    pathExists,
    repoRoots: pathExists.repoRoots,
    workflowCommands,
    workflowCommandKeys: new Set(workflowCommands.map(commandKey)),
  };
}

export function instructionFiles(root = '.') {
  const repositoryRoot = resolve(root);
  const explicit = [
    'AGENTS.md',
    'CLAUDE.md',
    'ARCHITECTURE.md',
    'README.md',
    'lib/AGENTS.md',
  ].filter(path => existsSync(join(repositoryRoot, path)));
  const directories = [
    'docs',
    '.claude/rules',
    '.claude/skills',
    '.claude/agents',
    '.cursor/rules',
    '.cursor/commands',
    '.github/workflows',
  ];
  const scanned = directories.flatMap(directory =>
    walk(join(repositoryRoot, directory))
      .filter(file => /\.(?:md|mdc|ya?ml)$/.test(file))
      .map(file => relative(repositoryRoot, file)),
  );

  return [...new Set([...explicit, ...scanned])]
    .filter(path => !isArchived(path))
    .sort();
}

export function main(root = process.cwd()) {
  const repositoryRoot = resolve(root);
  const index = buildIndex(repositoryRoot);
  const violations = instructionFiles(repositoryRoot).flatMap(path =>
    checkDocument({
      path,
      text: readFileSync(join(repositoryRoot, path), 'utf8'),
      index,
    }),
  );

  for (const violation of violations) {
    console.error(`${violation.path}:${violation.line}  ${violation.message}`);
  }
  if (violations.length > 0) {
    console.error(`\ninstruction claims: ${violations.length} unresolved claim(s)`);
    return 1;
  }

  console.log(
    'instruction claims: repository paths, App members, layer names, and CI commands resolve',
  );
  return 0;
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? '').href) {
  process.exitCode = main(process.argv[2] ?? process.cwd());
}
