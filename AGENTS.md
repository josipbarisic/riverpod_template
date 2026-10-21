# riverpod_template

Flutter application template with Riverpod code generation, Freezed models, GoRouter navigation,
Firebase integrations, and generated feature manifests.

## Start of task

1. Read this file.
2. Read `ARCHITECTURE.md` for stable layer and placement rules.
3. For feature work, read `lib/AGENTS.md`, regenerate manifests, then read
   `lib/manifests/<feature>.manifest.generated.json`.
4. Read every `.claude/rules/*.md` file whose `paths:` match files you may touch. Those files are
   the only copy of the coding rules. Claude Code attaches them by itself only in a session started
   in this repository; a session started elsewhere must read them.
   - `dart-state.md` — Riverpod codegen, state classes, `ref` access, `AsyncValue`
   - `dart-widgets.md` — base classes, one widget per file, keys on dynamic lists, overlay insets
   - `dart-conventions.md` — imports, naming, server-owned enums, logging, removal completeness
   - `dart-navigation.md` — path-based `AppRoute`, dialog pops, deeplink aliases
   - `claims-need-source.md` — repo-wide: resolve every claim against source
   - `no-tool-attribution.md` — repo-wide: no editor or assistant attribution
   - `commit-intent-routing.md` — repo-wide: commit intent runs the `commit` skill; message format
   - `post-task-learning.md` — repo-wide: the briefing and the traps-only learning log
5. Before editing a file, search `docs/LEARNING_LOG.md` for its path and feature directory
   (`rg -n '<path>' docs/LEARNING_LOG.md`); never read the whole log.
6. Inspect the live source and tests before citing a symbol, path, command, or behavior.

Use the complexity tier supplied by the user. If none was supplied, ask before editing:

- **Tier 1 — Quick:** one small, obvious change. Do minimal discovery and implement once clear.
- **Tier 2 — Moderate:** a few files with clear boundaries. Do short discovery, state a brief
  plan, then implement; no separate approval wait unless requested.
- **Tier 3 — Large:** broad, ambiguous, architectural, or cross-cutting work. Complete discovery,
  write the specification and implementation plan, and wait for explicit approval before editing.

A plan the user already approved counts as approval for the work it covers; ask for a tier only for
ad-hoc requests. Approval applies to the stated target and scope. Re-plan and ask again if implementation would
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

On Windows PowerShell, use `Get-Command fvm -ErrorAction SilentlyContinue`. If discovery succeeds, an agent may prefix the commands with `fvm`. If it does not, use the bare
commands. Never probe with `fvm spawn --help`, and never add, initialize, or change FVM as a
side-effect of another task.

Run `flutter analyze` after Dart changes. While iterating, run the narrowest relevant test path.
Before committing application, test, or platform changes, run `flutter test`; the current pull
request workflow runs the full unit/widget suite for those paths. Documentation-only and
instruction-only changes do not require Flutter tests.

Update tests when behavior changes in controllers, repositories, services, models, or widgets.
Tests mirror the current `test/` tree; do not invent a test directory from an architectural label.

## Claude Code hooks

`.claude/settings.json` registers thin adapters in `.claude/hooks/`. Shared policy lives under
`scripts/ai/`: SessionStart reports branch/base, changed-source manifest freshness, and
pending codegen; PreToolUse blocks manual edits to generated Dart and manifest files; PostToolUse
emits one debounced build-runner reminder; Stop runs the same integrity policy without blocking.
Stop results go to the local ignored file `.claude/last-session-status.json`.

`node scripts/ai/check_manifest_freshness.mjs` is the local manifest gate. It runs the generator,
compares each manifest with the checked-out copy ignoring `generatedAt`, restores every manifest,
and fails when one is out of date, including sources committed without their manifests.

`node scripts/ci/check_instruction_claims.mjs` validates repository paths, cited `App*` members,
layer names, and claimed CI command parity across canonical instructions. The Stop hook applies it
to changed instruction files; `.github/workflows/validate-ai-standards.yml` runs the complete
instruction inventory and its Node tests.

CI keeps `flutter analyze` blocking through
`scripts/ci/check_flutter_analyze_baseline.mjs`. The checker compares machine diagnostics with
`scripts/ci/flutter_analyze_baseline.json` by severity, lint code, repository-relative path, and
count. Existing diagnostics may be removed; a new diagnostic or an excess count fails.
`scripts/ci/check_riverpod_lint.sh` proves the `riverpod_lint` analyzer plugin from
`analysis_options.yaml` actually loaded (a temporary canary must report `missing_provider_scope`),
then applies the same baseline to the plugin's diagnostics.

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
Treat the live Dart source as authoritative if generated context disagrees. Revert a manifest diff
that only changes `generatedAt`. Preserve unrelated generated changes already present in the
worktree, and ask before staging a new untracked manifest.

## Architecture and state

- `lib/core/` contains shared routing, services, theme, configuration, and utilities.
- `lib/data/` contains external integrations and repositories.
- `lib/models/` contains application models.
- `lib/presentation/` is grouped by feature and contains views, controllers, states, and widgets.
- Riverpod providers and notifiers use annotation-based code generation only.

`ARCHITECTURE.md` owns stable architecture. `lib/AGENTS.md` owns feature and manifest guidance.
Path-scoped `.claude/rules/*.md` own code conventions.

## Work tracking

Work is tracked as GitHub issues on this repository's GitHub Project, named in
`.github/project.json`. `scripts/project/project.mjs` holds the rules below; the skills
`plan-issues`, `start-ticket`, `review-branch` and `board` drive them.

| Status | Set by |
|---|---|
| Backlog | `plan-issues` when it creates an issue, or the project's auto-add |
| Ready | the user, when the issue is next |
| In progress | `start-ticket`; or the Project Sync workflow, when a pull request closes unmerged and its issue was In review |
| In review | the Project Sync workflow, when a ready pull request that closes the issue opens |
| Merged | the Project Sync workflow, when that pull request merges; a closed parent stays Merged until every sub-issue is Done |
| Done | the Project Release workflow, when a published GitHub Release ships it; or an issue closed without a merged pull request |

The project's built-in "Item closed" rule sets Done the moment an issue closes, and "Pull request
merged" sets Merged on pull-request items. Project Sync then corrects an issue a merged pull
request closed back to Merged, so a closed issue reads Done briefly before it settles.

- Only a childless, unblocked issue is executable (`project.mjs check <n>`). A parent issue is a
  roll-up: it never gets a branch or pull request, and closes when its last sub-issue closes.
- Each issue has exactly one `type:*` label, and its body carries the headings of that type's form
  in `.github/ISSUE_TEMPLATE/`.
- Branch from `develop` with `gh issue develop <n> --name <n>-<slug>`. Pull requests target
  `develop` and carry one `Fixes #<n>` line per issue they fully complete; partial work uses
  `Refs #<n>`.
- Both workflows read the `PROJECT_TOKEN` secret, a classic token with the project and repo
  scopes; without it they skip, and the built-in rules alone leave closed issues at Done. Agents
  never create, read or set that token.

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
- `.claude/skills/*/SKILL.md`: workflow implementations only. They defer to `AGENTS.md` and
  canonical rules, and each skill's frontmatter owns when it runs.
- `.claude/agents/*.md`: read-only advisory reviewers. They report findings and never act as CI
  gates.
- `.claude/skills/commit/SKILL.md`: the local commit workflow, reached through
  `commit-intent-routing.md`.
- `scripts/project/project.mjs`: the only home of the work-tracking rules; the skills and the
  `project-*.yml` workflows call it.
- `.claude/rules/post-task-learning.md`: the Supervisor's Briefing contract.
- `.claude/skills/post-task-learning/SKILL.md`: the only allowed writer for the designated
  `docs/LEARNING_LOG.md`.
- `CLAUDE.md`: Claude-specific integration notes only.
