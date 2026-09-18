---
description: Logically remove a feature, widget, or file and all references with impact analysis and safety warnings
---

## Remove Feature / Widget / File

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, and the matching
`.claude/rules/*.md`. Remove the target and every reference that exists only
for it; preserve shared code.

## 1. Resolve the target

Identify the exact file, symbol, widget, route, provider, repository, model, or
feature. For a feature, regenerate and read its flat manifest before planning:

```text
lib/manifests/<feature>.manifest.generated.json
```

The live routing files are separate:

- `lib/core/routing/app_route.dart` — path constants
- `lib/core/routing/router.dart` — `GoRoute` registrations

## 2. Find the full reference set

Search `lib/`, `test/`, platform code, and relevant configuration for:

- imports and symbol references
- `AppRoute` paths and navigation call sites
- generated provider usages
- repository and model consumers
- tests, fixtures, and feature entry points

Classify each dependency as target-only or shared. The manifest is an index,
not proof that a reference is safe to delete.

## 3. Plan and confirm impact

List exact files to update, delete, and regenerate. If the target is a route,
shared widget, cross-feature provider, model, repository, or public entry point,
state the resulting behavior change and wait for explicit confirmation unless
the user's approved scope already covers it.

Never hand-edit generated files. Delete a generated Dart file only with its
removed source; regenerate other outputs.

## 4. Remove in dependency order

Remove entry points and call sites, then route registration and its `AppRoute`
constant, then imports and target-only supporting code, then source files.
Remove tests that assert deleted behavior and update tests for changed behavior.

Before Dart or Flutter commands, use the FVM discovery in root `AGENTS.md`.
Run the bare commands required by the change:

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
flutter analyze
flutter test <focused-test-path>
```

Report deleted, updated, and regenerated paths plus verification results. Do
not leave broken references or delete a flat manifest by hand.
