---
description: Review changes before committing - catch issues early
---

## Pre-Commit Review

Review all changes before committing to catch issues early.

### Step 1: Gather All Changes

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

Scan changed files for import violations:

```dart
// CORRECT — direct absolute import
import 'package:riverpod_template/presentation/login/login_view.dart';

// WRONG — relative import (REJECT)
import '../login/login_view.dart';
import '../../data/repositories/auth_repository/auth_repository.dart';
```

**Check for:**

- [ ] No relative imports (no `../` or `./`)
- [ ] All imports use `package:riverpod_template/...`
- [ ] Import order: dart → flutter → packages → project

### Step 5: NEVER Rules Check

For each changed file, verify:

**Type Safety:**

- [ ] No `dynamic` types
- [ ] No private `_build` methods (extract to widgets)

**Code Structure:**

- [ ] Views: UI only, no business logic
- [ ] Controllers: Logic only, use `@riverpod`
- [ ] Async operations have try-catch

**Generated Files:**

- [ ] Not editing `*.g.dart` or `*.freezed.dart`

**Routes:**

- [ ] Using `AppRoute.xxx` constants (no string literals)

### Step 6: File Size Guidelines

- Views: ≤250 lines (extract widgets if larger)
- Controllers: ≤150 lines (extract methods if larger)
- Repositories: ≤200 lines
- Widgets/Models: ≤100 lines

### Step 7: Code Generation (if providers/models changed)

```bash
dart run build_runner build -d
```

### Step 8: Anti-Drift Check

Review changes for scope drift:

- [ ] Only changes that were requested
- [ ] No "while I'm here" improvements
- [ ] No unrequested error handling
- [ ] No TODO/FIXME comments added
- [ ] No variable renames for "clarity"

### Step 9: Run Feature Tests

**Identify affected features from changed files:**

```bash
git diff --staged --name-only | grep "lib/presentation/" | cut -d'/' -f3 | sort -u
```

**Check if feature has tests (from manifest):**

```bash
cat lib/manifests/{feature}.manifest.generated.json | grep -A 10 '"testing"'
```

**Run feature-specific tests:**

```bash
flutter test test/presentation/{feature}/
```

**Test failure policy:**

- [ ] All feature tests must pass before committing
- [ ] If tests fail: fix code OR update tests (if behavior intentionally changed)
- [ ] Never skip or ignore failing tests

### Step 10: Run Full Verification

```bash
flutter analyze && flutter test
```

### Step 11: Generate Review Summary

```markdown
## Pre-Commit Review

### Security
- [ ] No secrets detected

### Direct Imports
- [ ] All imports use absolute package paths
- [ ] No relative imports found
- [ ] Import order correct

### NEVER Rules
- [ ] No `dynamic` types
- [ ] No `_build` methods
- [ ] Views: UI only
- [ ] Generated files untouched
- [ ] Routes follow AppRoute pattern

### File Sizes
- [ ] All within guidelines

### Code Generation
- [ ] Not needed / Run completed

### Scope
- [ ] No drift detected

### Feature Tests
- [ ] Identified affected features: [list]
- [ ] Feature tests passing: yes / N/A (no tests)

### Analysis & Tests
- [ ] analyze passed
- [ ] test passed

### Recommendation
[Ready to commit / Fix issues first]
```

### Step 12: Next Steps

If issues found → list them and ask to fix.

If clean → recommend running `/commit`.
