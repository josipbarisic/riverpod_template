---
name: manifest-freshness-checker
description: Detect stale lib/manifests/**/*.manifest.generated.json files whose underlying source Dart changed after generation. Use before feature work, during PR review, or when the sessionStart summary hints a manifest may be stale.
---

# Manifest Freshness Checker

Read-only: report staleness and the refresh command; never edit the generated
manifests.

## Relationship to the sessionStart hook

sessionStart prints a fast, mtime-based hint (loose — a `git checkout` can
over-report). This skill is the authoritative check using **git commit time**,
which ignores checkout mtime jitter. Confirm/correct the sessionStart line with
the method below.

## What "stale" means (align with CI — avoid false alarms)

CI regenerates the manifests and fails **only when regenerated CONTENT differs**
from what is committed — it **ignores the `generatedAt` timestamp**. A manifest
whose only diff is `generatedAt` is NOT stale; never report timestamp churn as a
failure.

### Authoritative check (matches CI exactly)

```bash
dart run scripts/generate_feature_manifests.dart
git diff -I'"generatedAt"' --stat lib/manifests       # content drift only
git diff -I'"generatedAt"' lib/manifests              # the actual drift
```

Any manifest still showing a diff is genuinely stale. Revert timestamp-only
churn afterwards with `git checkout -- <file>`.

### Fast hint (no generator run)

A cheaper pre-filter — confirm with the authoritative check before calling
anything stale (it over-reports on body-only source edits):

```bash
GEN_EPOCH=$(date -u -d "$GENERATED_AT" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "${GENERATED_AT%.*}" +%s)
git log -1 --format=%ct -- "$SRC"   # epoch of last commit touching the source
git status --porcelain -- "$SRC"    # non-empty => uncommitted working-tree edit
```

Sources: `views`, `controllers`, `widgets`, `models`, `repositories`,
`providers[].file`. Use a few-seconds tolerance.

## Report

```markdown
## Manifest Freshness

| Feature | Status | Stale source(s) |
|---|---|---|
| login | 🔴 stale | login_controller.dart |
| splash | 🟢 fresh | — |

Stale: N of M. Refresh:
    dart run scripts/generate_feature_manifests.dart
```

If all fresh, say so in one line.
