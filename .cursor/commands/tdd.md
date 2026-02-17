---
description: Test-driven development workflow
---

## Test-Driven Development (TDD)

Follow the **Red–Green–Refactor** cycle.

### Step 1: Understand Requirements

Ask: What should be tested? Expected behavior? Edge cases?

### Step 2: Mandatory Reads

1. Read testing patterns in `lib/AGENTS.md` (or `ARCHITECTURE.md` if present).
2. Read feature manifest: `lib/manifests/{feature}.manifest.generated.json`.
3. Check existing tests: `test/presentation/{feature}/`, `test/models/`, `test/repositories/`.

Use manifest: controller methods, state classes, dependencies to mock.

### Step 3: State What You Read

List files read and from manifest: controller, methods, state, dependencies.

### Step 4: RED – Write Failing Test

- Put tests in `test/presentation/{feature}/` or `test/repositories/` as appropriate.
- Use Arrange–Act–Assert; descriptive names.
- Test must fail initially (RED).

### Step 5: Run Test (Verify RED)

```bash
flutter test test/presentation/{feature}/  # or path to new test file
```

Confirm test fails.

### Step 6: GREEN – Minimal Implementation

Implement the minimum code so the test passes. No extra optimization yet.

### Step 7: Run Test (Verify GREEN)

Re-run the test; it should pass.

### Step 8: REFACTOR

Improve implementation (naming, structure, error handling). Re-run tests to ensure they still pass.

### Step 9: Repeat

Continue Red–Green–Refactor for more cases.

### Step 10: Final Verification

```bash
flutter test
```

Use mocktail for mocks; mock repositories/services, not the unit under test. Prefer one focused assertion per test where possible.
