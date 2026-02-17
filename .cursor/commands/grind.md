---
description: Batch operations for multiple similar changes
---

## Batch Operations (Grind)

For similar changes across many files (renames, import updates, pattern changes).

### Step 1: Identify Pattern

Ask: What must change? How many files? Exact pattern (e.g. rename method, update import).

### Step 2: Mandatory Reads

1. Read `lib/AGENTS.md` (or `ARCHITECTURE.md` if present).
2. Run: `dart run scripts/generate_feature_manifests.dart`
3. Find affected files (search/manifests).

### Step 3: State What You Read

List: files read, affected files with reason, pattern (from → to).

### Step 4: Verify Scope

Show user: list and count of files, impact. Confirm: proceed all / review some / cancel.

### Step 5: Execute by Tier

- **Tier 1** (<10 files): Execute.
- **Tier 2** (10–30): Show plan, then execute.
- **Tier 3** (>30): Show plan, **wait for approval**, then execute.

For each file: read → apply change → verify. Use absolute imports (`package:riverpod_template/...`).

### Step 6: Verify

```bash
flutter analyze && flutter test
```

If code gen or structure changed:

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
```

### Step 7: Summary

Report: files changed, pattern, status, tests ✓, analyze ✓.

Best practices: verify pattern on one file first; get approval for large batches; run full test suite after.
