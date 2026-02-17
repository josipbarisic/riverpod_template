---
description: Fix a GitHub issue by number or URL
---

## Fix GitHub Issue

**Repo:** Infer from `git remote get-url origin` or ask user for `org/repo`.

**Reference:** Complexity scale → `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`

### Usage

- `/fix-gh-issue 123`
- `/fix-gh-issue https://github.com/YOUR_ORG/riverpod_template/issues/123`

### Step 1: Parse Issue Reference

**If URL provided:** Extract issue number from URL (e.g. `issues/(\d+)`).  
**If number provided:** Use directly.

### Step 2: Fetch Issue Details

```bash
gh issue view {number} --repo YOUR_ORG/riverpod_template --json title,body,labels,comments,state,assignees
```

If GitHub CLI is not available or not authenticated: ask user for issue title and description, or guide them to run `gh auth login`.

### Step 3: Mandatory Reads (ZERO-DRIFT)

Before any code changes:

1. Read `lib/AGENTS.md` (or `ARCHITECTURE.md` if present) – code patterns, import rules.
2. Run: `dart run scripts/generate_feature_manifests.dart`
3. From issue content, identify affected feature(s) under `lib/presentation/`.
4. Read manifest for each: `lib/manifests/{feature}.manifest.generated.json`
5. Read feature README if present: `lib/presentation/{feature}/README.md`

From manifest use: `views`, `controllers`, `stateClasses`, `providers`, `routes`, `apiEndpoints`, `coreServices`, `thirdPartyDependencies`.

### Step 4: Assign Complexity

Ask user if not stated:

- **Tier 1 – Quick:** Single file, small fix. Minimal discovery → execute.
- **Tier 2 – Moderate:** A few files, clear scope. Short discovery + plan → execute.
- **Tier 3 – Large:** Many files or ambiguous. Full discovery + plan → **wait for approval** before implementing.

### Step 5: State What You Read

List files read and, from manifest, relevant views, controllers, routes, dependencies.

### Step 6: Plan and Implement

- **Tier 1:** Proceed once fix is clear.
- **Tier 2:** Brief plan (files to change), then implement.
- **Tier 3:** Full plan, then **wait for explicit approval** before implementing.

Use absolute imports only: `package:riverpod_template/...`. Follow pre-edit checklist and NEVER rules.

### Step 7: Code Generation (if needed)

If `@riverpod` / `@freezed` changed:

```bash
dart run build_runner build -d
```

### Step 8: Verify

```bash
flutter analyze && flutter test
```

Fix any failures; re-run until passing.

### Step 9: Regenerate Manifests (if structure changed)

```bash
dart run scripts/generate_feature_manifests.dart
```

### Step 10: Report

Summarize scope, files read, changes, and verification (analyze ✓ test ✓). For Tier 3, note that you waited for approval before implementing.
