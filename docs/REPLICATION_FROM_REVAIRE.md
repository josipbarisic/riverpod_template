# Replication from Revaire Mobile – Testing & Refactors

This document lists what to replicate from **revaire-mobile** (testing strategy, controller testability, manifest testing section, commands, and docs) into **riverpod_template** so every new project gets the same testing and AI workflow.

---

## 1. Analysis Summary (Revaire Mobile)

### Testing & Controller Refactors (Revaire)

- **Controllers** depend on repositories only via **Riverpod** (`ref.read(xxxRepositoryProvider)`). No direct `new Repository()` in controllers → easy to override in tests with a mock repository.
- **Manifest** includes a **`testing`** section: `testDirectory`, `testFiles`, `testDataFiles`, `runCommand`, `hasTests`. AI and devs can discover and run feature tests from the manifest.
- **Mocks** implement the **repository interface** and expose **stub methods** (e.g. `stubGetHotRoutes(List)`, `stubGetHotRoutesError(Exception)`) so tests set up behavior in one line.
- **Test data** lives in `test/test_data/{feature}_test_data.dart` with **factory functions** (`createHotRoute(...)`) and **pre-built constants** (`TestHotRoutes.list(2)`, `TestMetroAreas.newYork`).
- **Test layout**: `test/presentation/{feature}/` mirrors `lib/presentation/{feature}/`; controller tests and optional `mocks/` and widget tests live there.
- **AGENTS.md** has a full **Testing Workflow** (run feature tests when manifest says `hasTests`), **Manifest Testing Section** (schema), **Test Structure**, **Mocking** (mocktail, ProviderContainer overrides), and **Testing Requirements (MANDATORY)** (run `flutter test` before commit + table “If You Modified… → Update Test In…”).
- **docs/TESTING_STRATEGY.md** covers philosophy, pyramid, unit strategy, test organization, mocking, test data, implementation guide, best practices.
- **Manifest generator** has **TestingInfo** and **extractTestsForFeature()**: scans `test/presentation/{featurePath}/` for `*_test.dart` and `test/test_data/` for feature-named files; outputs `testing` in each manifest.
- **Commands**: **`/test`** (create tests: what to test, type, mandatory reads, location, mocks, templates for unit/widget/integration). **`/review`** includes or recommends running tests before commit.
- **Pre-commit**: All tests must pass; never commit with failing tests.

---

## 2. Replication Checklist for riverpod_template

Replicate the following in the template repo. Use **riverpod_template** package name and **RoutePath** / flat manifests where applicable.

### 2.1 Documentation

| Item | Action |
|------|--------|
| **docs/TESTING_STRATEGY.md** | Add (or adapt from revaire): testing philosophy, pyramid, unit strategy, test organization (`test/domain`, `test/presentation/{feature}/`, `test/repositories`, `test/services`, `test/helpers`, `test/test_data`), mocking strategy (mocktail, mock repositories, ProviderContainer overrides), test data patterns (factories + TestXxx constants), implementation guide, best practices. Use `package:riverpod_template/...` and `flutter test` (no `fvm` if template doesn’t use it). |
| **lib/AGENTS.md** | Add sections: **Testing Workflow** (when modifying a feature, check manifest `testing.hasTests`, run `runCommand`; test failure policy: must pass before commit). **Manifest Testing Section** (schema: `testDirectory`, `testFiles`, `testDataFiles`, `runCommand`, `hasTests`). **Test Structure** (test files under `test/presentation/{feature}/`, test data under `test/test_data/`, mocks under `test/presentation/{feature}/mocks/`). **Mocking** (mocktail, mock repositories not controllers, ProviderContainer with overrides). **Testing Requirements (MANDATORY)** (run `flutter test` before every commit; table “If You Modified… → Update Test In…”). |

### 2.2 Manifest Generator

| Item | Action |
|------|--------|
| **TestingInfo type** | Add to `scripts/generate_feature_manifests.dart`: class with `testDirectory`, `testFiles`, `testDataFiles`, `runCommand`, `hasTests` (derived from testFiles.isNotEmpty). |
| **extractTestsForFeature()** | Implement: scan `test/presentation/{featurePath}/` for `*_test.dart` (template uses flat features: splash, login, etc., so path is e.g. `test/presentation/login/`). Scan `test/test_data/` for files whose name contains the feature name; add to `testDataFiles`. Set `runCommand` to `flutter test test/presentation/{featurePath}/`. |
| **FeatureManifest** | Add `testing: TestingInfo` to the manifest model and to `toJson()` so every generated manifest includes a `testing` object. |
| **generateManifestForFeature()** | Call `extractTestsForFeature(featureName, featurePath)` and pass `testing` into `FeatureManifest`. |

### 2.3 Test Structure & Example

| Item | Action |
|------|--------|
| **test/presentation/** | Ensure at least one feature has a controller test, e.g. `test/presentation/login/login_controller_test.dart`, so the structure is established and the manifest generator can emit a non-empty `testing` section for that feature. |
| **Mocks** | Add one example mock that implements a repository interface and exposes stub methods (e.g. `MockAuthRepository` with `stubLoginSuccess(User)` / `stubLoginError(Exception)`). Place under `test/presentation/login/mocks/mock_auth_repository.dart` (or equivalent). Document in TESTING_STRATEGY or AGENTS that this is the preferred pattern. |
| **Test data** | Add or extend `test/test_data/` with at least one feature-specific file (e.g. `auth_test_data.dart` or reuse existing) containing factory functions and optional TestXxx constants, and reference it from a controller test. |

### 2.4 Controller Pattern (Testability)

| Item | Action |
|------|--------|
| **Document** | In ARCHITECTURE.md or AGENTS.md: controllers must obtain repositories (and other dependencies) via **Riverpod only** (e.g. `ref.read(authRepositoryProvider)`). No direct instantiation of repositories in controllers so that tests can override the provider with a mock. |
| **Template controllers** | Ensure existing controllers (e.g. login, splash) use `ref.read(xxxRepositoryProvider)` (or the template’s provider pattern) rather than constructing repositories directly. |

### 2.5 Cursor Commands

| Item | Action |
|------|--------|
| **.cursor/commands/test.md** | Add the **`/test`** command (from revaire): determine what to test (feature/file/method/widget/repository), test type (unit/widget/integration), mandatory reads (ARCHITECTURE, AGENTS, feature manifest, existing tests), state what you read, determine test location (`test/presentation/{feature}/`, `test/repositories/`, etc.), analyze dependencies to mock, create test structure (unit/widget/integration templates), implement tests, use test utilities, run tests. Adapt paths to template: `lib/manifests/{feature}.manifest.generated.json`, `package:riverpod_template/...`, `flutter test`. |
| **.cursor/commands/review.md** | Add a step: run **`flutter test`** (or recommend running tests) before commit; all tests must pass. |

### 2.6 Pre-Commit & Rules

| Item | Action |
|------|--------|
| **Pre-commit** | Document and enforce: run `flutter test` before every commit; do not commit with failing tests. (Already implied by revaire’s “Testing Requirements (MANDATORY)” – make it explicit in template README or CONTRIBUTING.) |
| **Rules** | Optionally add a short rule or mention in pre-edit-checklist / project-context: “When modifying a feature that has tests (manifest `testing.hasTests`), run the feature tests before committing.” |

---

## 3. Implementation Order

1. **Manifest generator**: Add `TestingInfo`, `extractTestsForFeature()`, and `testing` to `FeatureManifest`; run generator and confirm manifests include `testing`.
2. **AGENTS.md**: Add all testing sections (workflow, manifest testing schema, structure, mocking, mandatory requirements + table).
3. **docs/TESTING_STRATEGY.md**: Add full strategy doc adapted for template.
4. **Test structure**: Add one full example (e.g. login): `login_controller_test.dart`, `mocks/mock_auth_repository.dart`, and optional `test_data/auth_test_data.dart`.
5. **Commands**: Add `/test` and update `/review` with test step.
6. **ARCHITECTURE / controller pattern**: Document “controllers depend on Riverpod only” and ensure template controllers follow it.
7. **Pre-commit / README**: State that tests must pass before commit.

---

## 4. File-Level Summary

| Revaire source | Template target |
|----------------|-----------------|
| `lib/AGENTS.md` (testing sections) | `lib/AGENTS.md` (add sections) |
| `docs/TESTING_STRATEGY.md` | `docs/TESTING_STRATEGY.md` (create/adapt) |
| `scripts/generate_feature_manifests.dart` (TestingInfo + extractTestsForFeature) | `scripts/generate_feature_manifests.dart` (add) |
| `test/presentation/.../mocks/mock_*_repository.dart` (stub pattern) | `test/presentation/login/mocks/mock_auth_repository.dart` (example) |
| `test/test_data/*_test_data.dart` (factories + TestXxx) | `test/test_data/auth_test_data.dart` or extend existing |
| `test/presentation/.../*_controller_test.dart` (container, overrides, stub) | `test/presentation/login/login_controller_test.dart` (example) |
| `.cursor/commands/test.md` | `.cursor/commands/test.md` (create) |
| `.cursor/commands/review.md` (run tests step) | `.cursor/commands/review.md` (add step) |
| ARCHITECTURE / controller testability | `ARCHITECTURE.md` or `lib/AGENTS.md` (short subsection) |

---

**Last updated**: From revaire-mobile analysis (testing and controller refactors). Apply these items in riverpod_template so new projects get the same testing workflow and testable controller pattern.
