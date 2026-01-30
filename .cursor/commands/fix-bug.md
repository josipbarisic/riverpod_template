---
description: Fix a bug with proper context gathering
---

## Fix Bug

### Step 1: Understand the Bug

Ask: What is the bug? Which feature/screen? Expected vs actual behavior? Error messages? Steps to reproduce?

### Step 2: Mandatory Reads (ZERO-DRIFT)

Before any code changes:

1. Read `ARCHITECTURE.md` or `lib/AGENTS.md`
2. Run: `dart run scripts/generate_feature_manifests.dart`
3. Identify affected feature(s) from `lib/presentation/`
4. Read manifest: `lib/manifests/{feature}/{feature}.manifest.generated.json`
5. Read feature README (if exists): `lib/presentation/{feature}/README.md`
6. If bug involves API: read `lib/utils/network/endpoints.dart` or API docs

Extract from manifest: views, controllers, stateClasses, providers, routes, apiEndpoints, dependencies.

### Step 3: State What You Read

List files read and key manifest entries (views, controllers, routes, dependencies).

### Step 4: Complexity & Plan

- **Tier 1:** Single file, &lt;30 lines → Execute after minimal confirmation
- **Tier 2:** 2–5 files → State brief plan → Execute
- **Tier 3:** Larger → State plan → Wait for "proceed" → Execute

### Step 5: Investigate & Implement Fix

Use manifest to find relevant views, controllers, repositories. Fix using:

- Imports: `package:riverpod_template/...` only
- No `dynamic`, no private `_build*`, no logic in views
- Routes: use `RoutePath.xxx`

### Step 6: Verify

```bash
flutter analyze
flutter test
```

### Step 7: Regenerate Manifests (if structure changed)

```bash
dart run scripts/generate_feature_manifests.dart
```
