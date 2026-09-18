# Feature Guide

Use this file for work under `lib/`. Root `AGENTS.md` owns task complexity, commands, verification,
generated-file policy, and Git safety. `ARCHITECTURE.md` owns stable layer boundaries.

## Feature workflow

Before modifying a feature:

1. Run `dart run scripts/generate_feature_manifests.dart`.
2. Read `lib/manifests/<feature>.manifest.generated.json`.
3. Inspect the listed Dart source and relevant tests.
4. Read the canonical `.claude/rules/*.md` files whose `paths:` match the intended changes.

Never edit a manifest directly. If a manifest disagrees with source after regeneration, source is
authoritative; fix the generator only when generator behavior is inside the task.

## Feature manifests

Each `lib/manifests/<feature>.manifest.generated.json` may contain:

- `views`, `controllers`, and `widgets`
- model and repository dependencies
- generated Riverpod providers and state classes
- `AppRoute` route references
- controller method signatures
- repository API endpoint usage
- shared core services and third-party dependencies
- a `testing` object with discovered files and a focused run command

The generator reads the current `lib/presentation/` tree, routing source, repositories, and tests.
Regenerate after adding, moving, renaming, or removing views, controllers, routes, repositories,
providers, or feature tests.

## Current feature areas

| Feature | Source |
|---|---|
| Splash initialization | `lib/presentation/splash/` |
| Onboarding | `lib/presentation/onboarding/` |
| Login and verification | `lib/presentation/login/` |
| Registration | `lib/presentation/sign_up/` |
| Main tab shell | `lib/presentation/bottom_navigation/` |
| Home tab | `lib/presentation/home/` |
| Profile state | `lib/presentation/profile/` |

Shared presentation widgets currently live in `lib/presentation/widgets/`. Check the live tree
before adding a new feature or shared location.

## Layer placement

```text
lib/
├── core/          # Shared infrastructure and cross-feature utilities
├── data/          # Firebase integration and repositories
├── models/        # Application models
├── presentation/  # Feature views, controllers, states, and widgets
└── manifests/     # Generated feature context
```

- A view composes UI, watches render state, and wires events to a controller.
- A controller owns feature behavior and state transitions.
- A repository or service owns network, Firebase, storage, or other external I/O.
- Application models belong under `lib/models/`.
- Cross-feature infrastructure belongs in `lib/core/`; feature-only behavior stays with the
  feature.

## Riverpod and models

Use Riverpod code generation only. Providers use `@riverpod` or
`@Riverpod(keepAlive: true)`, include the matching `part` file, and access dependencies through
`Ref`. Do not add manually constructed provider objects.

The current source uses Equatable for small explicit presentation states and Freezed/JSON
generation for models. Use `AsyncValue<T>` directly when it fully represents controller state.

## Navigation

`lib/core/routing/app_route.dart` owns path constants. `lib/core/routing/router.dart` owns
`GoRoute` registrations. The current router is path-based, so call sites use `go` and `push` with
`AppRoute` constants. Update both files and regenerate manifests when routes change.

## Testing

Use the manifest's `testing.testFiles`, `testing.hasTests`, and `testing.runCommand` to discover
existing feature coverage. Confirm those paths in the live `test/` tree.

Current test locations are:

- controllers and feature behavior: `test/presentation/<feature>/`
- repositories: `test/repositories/`
- services: `test/services/`
- models: `test/domain/`
- utilities: `test/utils/`
- fixtures and helpers: `test/test_data/`, `test/helpers/`

Controller tests use `ProviderContainer` overrides. Mock repositories or external services rather
than controllers. Add tests for changed behavior; root `AGENTS.md` owns focused and full-suite
execution policy.
