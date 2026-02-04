---
description: Review changes before committing - catch issues early
---

## Pre-Commit Review

Review all changes before committing.

### Step 1: Gather Changes

```bash
git status
git diff --staged
git diff
```

### Step 2: Regenerate Manifests (if structure changed)

```bash
dart run scripts/generate_feature_manifests.dart
```

### Step 3: Security Audit

**BLOCK if found:** API_KEY, SECRET, client_secret, FIREBASE_, PRIVATE_KEY, sk- in staged or unstaged diff.

```bash
git diff --staged | grep -iE "(API_KEY|SECRET|client_secret|FIREBASE_|PRIVATE_KEY|sk-)" || echo "No secrets found"
git diff | grep -iE "(API_KEY|SECRET|client_secret|FIREBASE_|PRIVATE_KEY|sk-)" || echo "No secrets found"
```

### Step 4: Import Check

- [ ] No relative imports (`../`, `./`)
- [ ] All imports use `package:riverpod_template/...`
- [ ] Import order: dart → flutter → packages → project

### Step 5: NEVER Rules

- [ ] No `dynamic` types
- [ ] No private `_build*` methods (extract to widgets)
- [ ] Views: UI only; controllers: logic only
- [ ] Not editing `*.g.dart` or `*.freezed.dart`
- [ ] Routes use `AppRoute.xxx` (from `lib/core/routing/router.dart`)

### Step 6: File Size (guidelines)

- Views: ≤250 lines
- Controllers: ≤150 lines

### Step 7: Code Generation (if providers/models changed)

```bash
dart run build_runner build -d
```

### Step 8: Run Verification

```bash
flutter analyze
```

### Step 9: Run Tests

**All tests must pass before committing.**

```bash
flutter test
```

**If modifying a specific feature:**

1. Check manifest for `testing.hasTests`
2. Run feature tests: `flutter test test/presentation/{feature}/`

**If tests fail:**

- Fix failing tests before commit
- If new functionality, add corresponding tests

### Step 10: Summary

If issues found → list them and ask to fix. If clean → recommend running `/commit`.
