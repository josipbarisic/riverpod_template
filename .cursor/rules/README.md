# Cursor Rules (Riverpod Template)

Rules are the **source of truth** for how the agent writes code in this repo.
Commands and skills are workflows that *apply* these rules — when they diverge,
the rule wins.

## How Rules Apply

- **Always-applied** rules (`alwaysApply: true`) are injected into every request.
- **Glob-scoped** rules (front-matter `globs:`) apply only to matching files.
- Rules are `.mdc` files with YAML front-matter (`description`, and either
  `alwaysApply: true` or `globs:`).

## Rule Index

| Rule | Scope | Owns |
|---|---|---|
| `project-context.mdc` | always | Template structure, architecture, environments, build commands. |
| `discovery-first.mdc` | always | Tier 1/2/3 complexity model. Tier 3 = wait for approval. |
| `pre-edit-checklist.mdc` | always | Critical constraints: separate widget files, absolute imports, strict layers, no `dynamic`. |
| `ai-workflow.mdc` | always | When to read manifests, codegen commands, reference docs. |
| `commit-intent-routing.mdc` | always | Routes natural-language commit intent to the `git-commit` skill. |
| `no-tool-attribution.mdc` | always | Repo-wide: no Cursor/AI attribution in PRs, commits, code, or docs. |
| `post-task-learning.mdc` | always | Append a Supervisor's Briefing after every task; persist via the skill. |
| `dart-riverpod.mdc` | `**/*.dart` | Riverpod patterns, state classes, codegen, `AsyncValue`, `keepAlive`. |
| `dart-widget-rules.mdc` | `**/*.dart` | Widget structure, base-class selection, one class per file. |
| `dart-navigation.mdc` | `**/*.dart` | GoRouter patterns, `AppRoute` constants, navigation extensions. |
| `dart-imports.mdc` | `**/*.dart` | Absolute package imports; import ordering. |
| `dart-naming.mdc` | `**/*.dart` | File/class/provider naming. |
| `dart-expression-bodies.mdc` | `**/*.dart` | Arrow syntax vs block bodies. |

## Enforcement

Several rules are backed by automation so they can't silently drift:

- **Hooks** (`.cursor/hooks.json`) — block hand-edits to generated files, remind
  to run `build_runner`, and report branch/manifest/codegen status on session start.
- **CI** (`.github/workflows/validate-ai-standards.yml`) — enforces absolute
  imports, no `dynamic`, no private `_build` methods, manifest freshness, and
  config-file integrity.

## Authoring Conventions

- Filenames are kebab-case: `dart-<topic>.mdc`.
- Keep each rule focused on one concern; cross-reference rather than duplicate.
- Prefer `globs:` scoping over `alwaysApply` when a rule only affects some files.

## Related

- Skills: `.cursor/skills/README.md`
- Commands: `.cursor/commands/README.md`
- Complexity model: `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`
