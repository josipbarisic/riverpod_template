---
name: test
description: Create or update unit and widget tests for controllers, repositories, services, models, and views with mocktail doubles and ProviderContainer overrides, in standard or TDD mode. Use when writing or changing anything under test/, or when the user types /test.
paths: test/**
---

# Create Tests

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, and
`docs/TESTING_STRATEGY.md`. Read the source under test and the closest
existing test before writing a new one.

## 1. Fix the scope and mode

Resolve the behavior to pin and choose:

- unit test: controller, repository, service, model, or utility
- widget test: view rendering or interaction
- mode: **standard** for existing code, or **TDD** when the user asks for it

Do not create a test type or directory the repository does not already use
without the user's approval.

## 2. Ground in the live code

For feature work, regenerate and read
`lib/manifests/<feature>.manifest.generated.json`. Take controller methods,
state classes, dependencies to replace, and testing metadata from it, then
confirm each in source. State what you read before writing:

```markdown
**FILES READ**: manifest, source under test, nearest existing test
**BEHAVIOR TO PIN**: methods and state transitions, including the failure path
**DOUBLES**: repositories or services to replace, and the existing mock to reuse
```

Reuse the nearest existing pattern, for example
`test/presentation/login/login_controller_test.dart` with
`test/presentation/login/mocks/mock_auth_repository.dart` and
`test/test_data/auth_test_data.dart`, or `test/helpers/mock_network_service.dart`
for network code.

## 3. Place the test

| Target | Location |
|---|---|
| Controller or state | `test/presentation/<feature>/<name>_test.dart` |
| Feature view or widget | `test/presentation/<feature>/` |
| Repository | `test/repositories/<name>_repository_test.dart` |
| Service | `test/services/` |
| Model | `test/domain/<model>_test.dart` |
| Utility | `test/utils/` |
| Test data factory | `test/test_data/<name>_test_data.dart` |
| Mock | `test/presentation/<feature>/mocks/` or `test/helpers/` |

## 4. Write the test

Use Arrange-Act-Assert with `mocktail`. Build controllers through a
`ProviderContainer` with provider overrides, and override repositories or
services rather than controllers. Override a class provider with a notifier,
never with a value. When an auto-dispose provider must survive between reads,
keep it alive with `container.listen`.

Cover what matters for the target: the success, empty, and error results of
`build()`, each state transition a method performs, validation, and the edge
cases the source handles (null, empty, and boundary values).
`docs/TESTING_STRATEGY.md` owns widget-test techniques.

In TDD mode:

1. **Red**: write the test for the desired behavior and run it; it must fail
   for the missing behavior, not for a syntax or setup error.
2. **Green**: implement the minimum that passes and run it again.
3. **Refactor**: improve naming and structure with the test still green, then
   repeat for the next behavior.

## 5. Run and report

After the FVM discovery in root `AGENTS.md`, run the focused path first:

```bash
flutter test <focused-test-path>
```

Then run the broader verification root `AGENTS.md` requires. Report the
behavior pinned, the test files changed, the mode, and the exact commands and
results.
