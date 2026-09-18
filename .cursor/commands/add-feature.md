---
description: Add a new feature/screen following layer-based architecture patterns
---

## Add New Feature

Use root `AGENTS.md` for complexity. Tier 3 requires full discovery, a written
specification and plan, and explicit approval before implementation.

## 1. Ground the feature

Resolve the user flow, route entry, data source, mutations, loading/error/empty
states, integration points, and non-goals. Ask only questions that change the
implementation.

Read:

- `AGENTS.md`, `ARCHITECTURE.md`, and `lib/AGENTS.md`
- matching `.claude/rules/*.md`
- a regenerated flat manifest for the closest existing feature
- the similar live source and tests
- endpoint or external contract source when data is involved

Use `.claude/skills/feature-planning/SKILL.md` for the planning workflow.

## 2. Plan against live architecture

Place code only where needed:

- `lib/presentation/<feature>/` for views, controllers, states, and local widgets
- `lib/data/repositories/` for data access
- `lib/models/` for application models
- `lib/core/` for genuinely shared infrastructure
- `lib/presentation/widgets/` for app-wide widgets

Use Riverpod annotation code generation only. Add route paths to
`lib/core/routing/app_route.dart`, register them in
`lib/core/routing/router.dart`, and use `go` or `push` with the `AppRoute`
value. Plan tests from the current `test/` tree.

## 3. Implement after the tier checkpoint

Follow the approved plan and canonical rules. Do not invent a feature README,
repository, state class, or model when the behavior does not need one. Do not
edit generated Dart or manifest files.

## 4. Generate and verify

Before Dart or Flutter commands, perform root `AGENTS.md` FVM discovery. Run
the applicable bare commands:

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
flutter analyze
flutter test <focused-test-path>
```

Report created, updated, and generated paths; integration points; tests; and
verification results. Remove any work outside the approved scope.
