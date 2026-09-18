# riverpod_template

Flutter application template with Riverpod code generation, Freezed models, GoRouter navigation,
Firebase integrations, and generated feature manifests.

## Start of task

1. Read this file.
2. Read `ARCHITECTURE.md` for stable layer and placement rules.
3. For feature work, read `lib/AGENTS.md`, regenerate manifests, then read
   `lib/manifests/<feature>.manifest.generated.json`.
4. Read every `.claude/rules/*.md` file whose `paths:` match files you may touch. Those files are
   the canonical coding rules; `.cursor/rules/*.mdc` only attach pointers to them.
5. Inspect the live source and tests before citing a symbol, path, command, or behavior.

Use the complexity tier supplied by the user. If none was supplied, ask before editing:

- **Tier 1 — Quick:** one small, obvious change. Do minimal discovery and implement once clear.
- **Tier 2 — Moderate:** a few files with clear boundaries. Do short discovery, state a brief
  plan, then implement; no separate approval wait unless requested.
- **Tier 3 — Large:** broad, ambiguous, architectural, or cross-cutting work. Complete discovery,
  write the specification and implementation plan, and wait for explicit approval before editing.

Approval applies to the stated target and scope. Re-plan and ask again if implementation would
materially exceed it.

## Build, test, and lint

Commands are written in their portable bare form:

```bash
flutter pub get
flutter analyze
flutter test
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor prod -t lib/main_prod.dart
```

Before running Flutter or Dart, discover FVM without executing it:

```bash
command -v fvm
```

If discovery succeeds, an agent may prefix the commands with `fvm`. If it does not, use the bare
commands. Never probe with `fvm spawn --help`, and never add, initialize, or change FVM as a
side-effect of another task.

Run `flutter analyze` after Dart changes. While iterating, run the narrowest relevant test path.
Before committing application, test, or platform changes, run `flutter test`; the current pull
request workflow runs the full unit/widget suite for those paths. Documentation-only and
instruction-only changes do not require Flutter tests.

Update tests when behavior changes in controllers, repositories, services, models, or widgets.
Tests mirror the current `test/` tree; do not invent a test directory from an architectural label.

## Local editor hooks

`.claude/settings.json` and `.cursor/hooks.json` register thin editor adapters. Shared policy lives
under `scripts/ai/`: SessionStart reports branch/base, changed-source manifest freshness, and
pending codegen; PreToolUse blocks manual edits to generated Dart and manifest files; PostToolUse
emits one debounced build-runner reminder; Stop runs the same integrity policy without blocking.
Stop results are local ignored files at `.claude/last-session-status.json` and
`.cursor/last-session-status.json`.

`node scripts/ai/check_manifest_freshness.mjs` is the read-only local manifest gate. It reports
changed generator inputs without regenerating or rewriting manifests.

`node scripts/ci/check_instruction_claims.mjs` validates repository paths, cited `App*` members,
layer names, and claimed CI command parity across canonical instructions. The Stop hook applies it
to changed instruction files; `.github/workflows/validate-ai-standards.yml` runs the complete
instruction inventory and its Node tests.

CI keeps `flutter analyze` blocking through
`scripts/ci/check_flutter_analyze_baseline.mjs`. The checker compares machine diagnostics with
`scripts/ci/flutter_analyze_baseline.json` by severity, lint code, repository-relative path, and
count. Existing diagnostics may be removed; a new diagnostic or an excess count fails.

## Generated files and manifests

Never hand-edit:

- `*.g.dart`
- `*.freezed.dart`
- `lib/manifests/*.manifest.generated.json`

After changing `@riverpod`, `@Riverpod`, `@freezed`, or JSON-serializable source, run
`dart run build_runner build -d`. After adding, moving, renaming, or removing feature views,
controllers, routes, repositories, or providers, run
`dart run scripts/generate_feature_manifests.dart`.

Before feature implementation, regenerate manifests and inspect the relevant generated JSON.
Treat the live Dart source as authoritative if generated context disagrees. Preserve unrelated
generated changes already present in the worktree, and ask before staging a new untracked
manifest.

## Architecture and state

- `lib/core/` contains shared routing, services, theme, configuration, and utilities.
- `lib/data/` contains external integrations and repositories.
- `lib/models/` contains application models.
- `lib/presentation/` is grouped by feature and contains views, controllers, states, and widgets.
- Riverpod providers and notifiers use annotation-based code generation only.

`ARCHITECTURE.md` owns stable architecture. `lib/AGENTS.md` owns feature and manifest guidance.
Path-scoped `.claude/rules/*.md` own code conventions.

## Git and safety

- Inspect `git status` before editing and preserve changes you did not create.
- Do not commit or push unless the user explicitly asks.
- Never run destructive or history-rewriting Git commands without explicit approval.
- Never use `git stash --all`; it can capture ignored credentials. Use `git stash` or
  `git stash --include-untracked` only when the task requires it.
- Never commit `.env`, signing material, keystores, provisioning profiles, tokens, or
  credentials.
- Confirm untracked files before staging them. Do not use `git add .` or `git add -A` blindly.
- Do not add editor, assistant, or generation-tool attribution to repository artifacts.

## Instruction, skill, and learning ownership

- `AGENTS.md`: task workflow, complexity, commands, generated-file policy, testing, and Git safety.
- `ARCHITECTURE.md`: stable layers, data flow, and placement.
- `lib/AGENTS.md`: feature map, manifests, and feature-test discovery.
- `.claude/rules/*.md`: the only canonical copy of path-scoped rules.
- `.cursor/rules/*.mdc`: attachment pointers only; they never duplicate rule text.
- `.claude/skills/*/SKILL.md`: workflow implementations only. They defer to `AGENTS.md` and
  canonical rules.
- `.claude/agents/*.md`: read-only advisory reviewers. They report findings and never act as CI
  gates.
- `.cursor/commands/*.md`: the ten slash-command entry points; `.cursor/commands/README.md` is
  their index.
- `.claude/skills/git-commit/SKILL.md`: the local commit workflow, reached through
  `commit-intent-routing.md`.
- `.claude/rules/post-task-learning.md`: the Supervisor's Briefing contract.
- `.claude/skills/post-task-learning/SKILL.md`: the only allowed writer for the designated
  `docs/LEARNING_LOG.md`.
- `CLAUDE.md`: Claude-specific integration notes only.
