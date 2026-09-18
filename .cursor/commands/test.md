---
description: Create tests (unit, widget, or integration) — standard or TDD mode
---

## Create Tests

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, and
`docs/TESTING_STRATEGY.md`. Read the source under test and the closest existing
test before writing a new one.

## 1. Fix the behavior boundary

Resolve the target behavior and choose:

- controller, repository, service, model, or utility unit test
- widget rendering or interaction test
- integration flow test
- TDD when explicitly requested

Do not create a test type or directory that the repository does not already
support without user approval.

## 2. Use the live test layout

- controllers and feature behavior: `test/presentation/<feature>/`
- repositories: `test/repositories/`
- services: `test/services/`
- models: `test/domain/`
- utilities: `test/utils/`
- fixtures and helpers: `test/test_data/`, `test/helpers/`

For feature work, regenerate and read
`lib/manifests/<feature>.manifest.generated.json`, then verify its testing paths
in the live tree. Application models live under `lib/models/`.

## 3. Write the narrowest useful test

Use `ProviderContainer` overrides for generated Riverpod providers. Mock
repositories, services, SDKs, or platform boundaries rather than controllers.
Test public behavior and state transitions, including the failure path that
matters. Follow imports, fixtures, setup, and matchers from the nearest existing
test.

In TDD mode, run the new test red, implement the minimum behavior, then run it
green before refactoring.

## 4. Run and report

Before Flutter or Dart commands, perform the FVM discovery from root
`AGENTS.md`. Run the bare focused command first:

```bash
flutter test <focused-test-path>
```

Then run any broader verification required by `AGENTS.md`. Report the behavior
pinned, changed test paths, and exact commands and results.
