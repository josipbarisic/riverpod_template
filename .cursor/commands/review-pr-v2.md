---
description: Review the current PR/branch by dispatching specialised reviewers based on the files that changed
---

## Review PR v2

Reviews the changes on the current branch by detecting which kinds of files
changed and dispatching the matching specialised reviewer(s), then aggregating
their findings into one severity-grouped report. Each reviewer maps to a Cursor
skill.

### Step 0: Log usage

```bash
mkdir -p .cursor/usage && echo '{"command":"/review-pr-v2","timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%S)'"}' >> .cursor/usage/command-log.jsonl
```

### Step 1: Collect the changed files

Determine the base branch (argument if given, else `develop`, else `main`) and
list changed files:

```bash
BASE="develop"
git diff --name-only "$(git merge-base HEAD "origin/$BASE" 2>/dev/null || git merge-base HEAD "$BASE")"...HEAD
```

Exclude generated files (`*.g.dart`, `*.freezed.dart`, `*.manifest.generated.json`).

### Step 2: Route to reviewers (repo detection)

Run every reviewer whose trigger matches the changed set. Each reviewer is a
Cursor skill; follow the matching `SKILL.md` for that file kind.

| Reviewer skill | Trigger (files changed) |
|---|---|
| `flutter-code-review` | any non-generated `*.dart` file |
| `riverpod-pattern-auditor` | `*.dart` with `@riverpod`/`@Riverpod`, a `_$` Notifier, or `*_controller.dart` / `*_provider.dart` / `*_repository.dart` |
| `manifest-freshness-checker` | any `lib/presentation/**/*.dart` or `*.manifest.generated.json` change |
| `widget-placement-auditor` | any **added or renamed** `lib/presentation/**/*.dart` widget/view file |
| `route-integrity-auditor` | any change to `router.dart`, `app_route.dart`, or a deep-link/notification handler |

### Step 3: Aggregate

Merge all reviewer outputs into a single report, de-duplicating overlapping
findings and preserving each finding's `file.dart:line` citation:

```markdown
## PR Review: {branch} → {base}

### 🔴 Critical (must fix)
### 🟡 Warnings
### 🟢 Good patterns

### Summary
- Reviewers run: {list}
- Critical: X · Warnings: Y
- Recommendation: [block until critical fixed / ready to merge]
```

### Rules

- Read-only review: do not edit files.
- If no reviewable files changed, say so and stop.
- Never recommend merge while a Critical finding is open.
