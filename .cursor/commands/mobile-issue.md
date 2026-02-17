---
description: Report or debug a mobile issue in the app
---

## Mobile Issue Investigation

### Step 1: Mandatory Reads (ZERO-DRIFT)

Before investigating:

1. Read `lib/AGENTS.md` (or `ARCHITECTURE.md` if present) – code patterns, layer structure.
2. Run: `dart run scripts/generate_feature_manifests.dart`

### Step 2: Ask About the Issue

Get from the user:

- Which feature/screen is affected?
- Expected vs actual behavior.
- Any error messages or logs.
- Steps to reproduce.

### Step 3: Read Feature Context

Read manifest for the affected feature:

- `lib/manifests/{feature}.manifest.generated.json`
- `lib/presentation/{feature}/README.md` (if exists)

Use from manifest: `views`, `controllers`, `stateClasses`, `providers`, `routes`, `apiEndpoints`, `coreServices`, `thirdPartyDependencies`.

### Step 4: State What You Read

List files read and, from manifest, relevant views, controllers, routes, dependencies.

### Step 5: Investigate

Using manifest and codebase:

- Check relevant views and controllers.
- Follow dependency chain if needed.
- Look for similar patterns in other features.
- Check error handling in repositories and API usage.

### Step 6: Follow Fix Workflow

Once root cause is identified, follow `/fix-bug` workflow (complexity tier, NEVER rules, verify, report).

### Step 7: Report Findings

Summarize: **Issue**, **Root cause**, **Affected files**, **Recommended fix**. If simple, proceed with fix; if complex, wait for approval.
