---
description: Analyse a feature with manifest-based discovery and structured report
---

## Analyse Feature

Produce a structured report for a feature using the manifest and codebase.

### Step 1: Identify Feature

Ask user which feature to analyse, or infer from context (e.g. path under `lib/presentation/`). Examples: `splash`, `login`, `sign_up`, `onboarding`, `bottom_navigation`, `home`.

### Step 2: Mandatory Reads

1. Read `lib/AGENTS.md`
2. Read manifest: `lib/manifests/{feature}/{feature}.manifest.generated.json`  
   (If missing or path differs, list `lib/manifests/` and pick the right file.)
3. Check staleness: compare `generatedAt` to modification time of files in `exports`. If stale, recommend: `dart run scripts/generate_feature_manifests.dart`
4. Read feature README (if exists): `lib/presentation/{feature}/README.md`
5. Skim key files from manifest: main view(s), controller(s), repository if any

### Step 3: Produce Report

Write a short structured report:

```markdown
## Feature: [name]

### Purpose
- What the feature does (from README or code).

### Structure (from manifest)
- **Views:** [list]
- **Controllers:** [list]
- **Widgets:** [list]
- **Routes:** [list with AppRoute / path]
- **Providers:** [list]
- **Repositories / API:** [list or "none"]
- **Dependencies:** [list]

### Strengths
- Patterns used well (e.g. Riverpod, Freezed, routing).

### Gaps / Recommendations
- Missing tests, docs, or possible refactors.
- Staleness: [manifest up-to-date or suggest regenerate]
```

### Step 4: Suggest Next Steps

If user asked for refactor or onboarding, suggest concrete next steps (e.g. add tests, update README, regenerate manifests).
