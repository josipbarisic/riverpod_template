---
name: feature-planning
description: Ground and plan a Flutter feature against the live architecture, generated feature manifest, integration points, and tests. Use for new features, implementation plans, or "how should I build this" requests.
---

# Feature Planning

Produce an implementation-ready plan without editing product code. Root
`AGENTS.md` owns complexity and approval; a Tier 3 plan stops for explicit
approval.

## 1. Ground the request

Resolve the user-visible behavior, entry point, data source, mutations, loading
and failure states, and scope boundaries. Ask only questions that materially
change the design.

## 2. Read canonical context

From the repository root:

1. Read `AGENTS.md`, `ARCHITECTURE.md`, and `lib/AGENTS.md`.
2. Read every `.claude/rules/*.md` file whose `paths:` match likely changes.
3. Run the manifest generator and read the closest flat manifest:

   ```bash
   dart run scripts/generate_feature_manifests.dart
   ```

   Before Dart, discover FVM with `command -v fvm`; prefix the bare command
   only when discovery succeeds.
4. Inspect the live source and tests behind every proposed symbol. A manifest
   is generated context, not authority.

Use the current architecture:

- views, controllers, states, and feature widgets under
  `lib/presentation/<feature>/`
- repositories under `lib/data/repositories/`
- application models under `lib/models/`
- shared infrastructure under `lib/core/`
- shared widgets under `lib/presentation/widgets/`
- path constants in `lib/core/routing/app_route.dart`
- `GoRoute` registrations in `lib/core/routing/router.dart`
- flat manifests at `lib/manifests/<feature>.manifest.generated.json`

## 3. Design the state and boundaries

Use Riverpod annotation code generation only. Name the generated provider,
controller state shape, repository dependencies, and invalidation behavior.
Keep external I/O in repositories or services and feature behavior in the
controller.

Decompose route-level screens into `*View` classes and coherent widget files
according to `.claude/rules/dart-widgets.md`. Do not invent model, shared-widget,
or test locations that the live tree does not use.

## 4. Reconcile navigation and tests

For every route, plan both the `AppRoute` path constant and its `GoRoute`.
Navigation call sites use the path value with `go` or `push` unless the router
is deliberately changed to register names.

Map behavior changes to the existing test tree. Use manifest testing metadata
only as a discovery aid, then verify each path under `test/`.

## 5. Present the plan

Include:

- scope and explicit non-goals
- user flow and state transitions
- files to add, update, regenerate, or delete
- controller, repository, model, route, and test responsibilities
- integration points and risks
- verification commands from root `AGENTS.md`

Do not estimate lines or prescribe optional files as mandatory. For Tier 3,
finish with an explicit approval checkpoint and make no implementation edits.

## 6. Implement after approval

Follow the approved plan and canonical rules. Do not invent a feature README,
repository, state class, or model the behavior does not need, and do not edit
generated Dart or manifest files. After root `AGENTS.md` FVM discovery, run:

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
flutter analyze
flutter test <focused-test-path>
```

Report created, updated, and generated paths, integration points, tests, and
verification results. Remove any work outside the approved scope.
