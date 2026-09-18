# Cursor Commands

These ten slash commands are thin entry points into the repository workflow.
Root `AGENTS.md` owns complexity, FVM discovery, generation, testing, and Git
safety. Canonical conventions live in `.claude/rules/*.md`.

## Current commands

1. `/fix` — diagnose and implement a scoped issue or bug fix
2. `/add-feature` — plan and implement a feature using the live architecture
3. `/refine-feature` — improve an existing feature without scope drift
4. `/analyse` — read-only feature analysis grounded in source and its manifest
5. `/test` — add focused unit, widget, or integration coverage
6. `/remove` — remove a file or feature after reference and impact analysis
7. `/review-pr-v2` — read-only branch review using canonical reviewer agents
8. `/enhance-prompt` — ground a raw task prompt in verified repository context
9. `/review-learnings` — read-only review of `docs/LEARNING_LOG.md`
10. `/start-new-project` — gather requirements and plan a template-derived app

Natural-language commit intent is routed by
`.claude/rules/commit-intent-routing.md` to
`.claude/skills/git-commit/SKILL.md`.

## Shared command model

- Read root `AGENTS.md` first and use its supplied or requested complexity tier.
- For feature work, follow `lib/AGENTS.md`, regenerate, and read the flat
  `lib/manifests/<feature>.manifest.generated.json`.
- Treat live `lib/` and `test/` source as authoritative.
- Use `lib/models/` for application models.
- Update route paths in `lib/core/routing/app_route.dart` and registrations in
  `lib/core/routing/router.dart`.
- Use Riverpod annotation code generation only.
- Run bare Dart and Flutter commands from the repository root after the FVM
  discovery defined by `AGENTS.md`.

Reusable workflows live in `.claude/skills/`. Read-only advisory reviewers live
in `.claude/agents/` and never act as CI gates.
