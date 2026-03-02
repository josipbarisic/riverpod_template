---
description: Add a new feature/screen following layer-based architecture patterns
---

## Add New Feature

### Step 0: Log Usage

```bash
mkdir -p .cursor/usage && echo '{"command":"/add-feature","timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%S)'"}' >> .cursor/usage/command-log.jsonl
```

---

### Step 0a: Complexity (MANDATORY)

Ask the user if not stated:

- **Tier 1 – Quick:** Single file, small change → 0–1 questions → execute
- **Tier 2 – Moderate:** Few files, clear scope → short discovery + plan → execute
- **Tier 3 – Large:** New feature, multiple screens → full discovery + plan → **wait for approval**

### Step 0b: Development Approach

Ask the user:

- **TDD** — tests first, then implement (recommended Tier 2–3)
- **Implementation First** — implement, add tests after
- **Implementation Only** — no tests (not recommended)

---

### Step 1: Requirements (depth by tier)

**Tier 1:** 0–1 questions, then proceed.

**Tier 2:** Feature name, screens needed, data involved, how user reaches it.

**Tier 3:** All Tier 2 plus: which API(s), similar feature to reference, integration points in
existing UI.

### Step 2: Context Gathering

1. Read similar feature's manifest: `lib/manifests/{similar}.manifest.generated.json`
2. Read similar feature's README if it exists
3. If API calls: read endpoint definitions or API docs
4. Identify integration points — where does this feature appear in existing UI? Which existing
   providers/views need updates?

State what you read and what patterns you'll follow.

### Step 3: Plan

**Tier 1:** No written plan needed — proceed.

**Tier 2:** State brief plan (files to create/modify), then implement.

**Tier 3:** State full plan and **STOP — wait for approval**:

```
SCOPE: Add [{feature_name}]
TIER 3 — APPROVAL REQUIRED
APPROACH: [TDD / Implementation First / Implementation Only]

Feature files:
1. lib/presentation/{feature}/{feature}_view.dart
2. lib/presentation/{feature}/{feature}_controller.dart
3. lib/data/repositories/{feature}_repository/{feature}_repository.dart
4. lib/domain/{feature}/ (if needed)
5. Route: router.dart (AppRoute constant + GoRoute)

Tests (if applicable):
6. test/test_data/{feature}_test_data.dart
7. test/presentation/{feature}/mocks/mock_{feature}_repository.dart
8. test/presentation/{feature}/{feature}_controller_test.dart

Integration:
9. [list existing files that need updates]

Waiting for approval.
```

---

### Step 4: Implement

Follow `.cursor/rules/dart-*.mdc` for all code patterns.

**After writing each file, immediately verify:**

- No `Widget _build` methods → extract to separate widget file
- No `import '../` → use `package:riverpod_template/...`
- No `: dynamic` → use specific types

If any found, fix before moving to next file.

**File size targets:** views ≤250L, controllers ≤150L, repos ≤200L, widgets ≤100L.

**Routes:**

1. Add constant in `lib/core/routing/router.dart` → `static const String name = '/name';`
2. Add `GoRoute` in same file with `path: AppRoute.name` and builder returning the view.

### Step 5: Code Generation & Manifests

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
```

### Step 6: Tests

- **TDD:** Tests already written — verify green.
- **Implementation First:** Create tests now. Reference an existing feature with tests for patterns.
- **Implementation Only:** Ask user if they want to add tests.

```bash
flutter test test/presentation/{feature}/
```

### Step 7: Verify

```bash
flutter analyze && flutter test
```

### Step 8: Anti-Drift Check

Verify you did NOT: add unrequested functionality, create unlisted files, miss integration points,
add TODOs/FIXMEs, or rename variables "for clarity". Undo any drift.

### Step 9: Documentation

Create `lib/presentation/{feature}/README.md` with: overview, business context, key files,
integration points, API (if any), testing.

### Step 10: Report

```
SCOPE: [{feature_name}]
APPROACH: [TDD / Implementation First / Implementation Only]
FILES: [list created/modified files with brief description]
INTEGRATION: [where feature connects to existing code]
TESTS: X passing / Skipped
VERIFIED: analyze passed, test passed, manifests regenerated
```
