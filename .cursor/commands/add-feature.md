---
description: Add a new feature/screen following template architecture
---

## Add New Feature

**Reference:** `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`

---

### Step 0: Assign Complexity (MANDATORY FIRST)

Ask the user if not already stated:

- **Tier 1 – Quick:** One small addition. Minimal discovery, then execute.
- **Tier 2 – Moderate:** A few new files, clear scope. Short discovery + plan, then execute.
- **Tier 3 – Large:** New feature, multiple screens, or ambiguous. Full discovery, spec, plan — then **wait for approval** before implementing.

---

### Step 1: Gather Requirements (Depth by Tier)

**Tier 1:** 0–1 questions.

**Tier 2:** Feature name, what screens/data, how user reaches it (3–5 questions).

**Tier 3:** Feature name, screens/views, data, repository API(s), navigation (AppRoute), similar feature to copy from, integration points.

---

### Step 2: Mandatory Reads (ZERO-DRIFT)

**Tier 2–3:** Before any code changes:

1. Read `ARCHITECTURE.md` (or `lib/AGENTS.md`)
2. Run: `dart run scripts/generate_feature_manifests.dart`
3. Read similar feature manifest: `lib/manifests/{similar}/{similar}.manifest.generated.json`
4. Read similar feature README (if exists): `lib/presentation/{similar}/README.md`
5. If API calls involved, read `lib/core/utils/network/endpoints.dart` or API docs

Extract from manifest: exports.views, exports.controllers, providers, routes, apiEndpoints, dependencies.

---

### Step 3: State Plan (Tier 2–3)

State what you will create: files, routes, controllers, views. For Tier 3, wait for explicit approval.

---

### Step 4: Implementation

**Imports:** Always use `package:riverpod_template/...`. Never relative imports.

**Routes:**

1. Add constant in `lib/core/routing/router.dart` (class `AppRoute`):
   ```dart
   static const String myFeature = '/myFeature';
   ```
2. Add `GoRoute` in same file with `path: AppRoute.myFeature` and builder returning the view.

**NEVER:** relative imports, `dynamic`, private `_build*` methods, logic in views, editing `*.g.dart`/`*.freezed.dart`.

**File size:** Views ≤250 lines, controllers ≤150 lines.

---

### Step 5: Code Generation & Manifests

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
```

---

### Step 6: Verification

```bash
flutter analyze
flutter test
```

---

### Step 7: Report

State what was created (files, routes) and that manifests were regenerated.
