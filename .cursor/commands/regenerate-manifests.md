---
description: Regenerate feature manifests after structural changes
---

## Regenerate Feature Manifests

Regenerate all feature manifests to keep them up-to-date with the codebase.

### When to Run

- **After** adding new views, controllers, routes, or repositories
- **After** renaming or moving files
- **After** modifying route definitions in `lib/core/routing/router.dart`
- **Before** using other commands that rely on manifests

### Step 1: Run Manifest Generator

```bash
dart run scripts/generate_feature_manifests.dart
```

### Step 2: Verify Output

The script outputs generated manifest paths under `lib/manifests/`. Check for errors (e.g. missing feature directories).

### Step 3: If Errors Occur

- Run `dart analyze` first
- Verify route definitions in `lib/core/routing/router.dart` and `AppRoute` constants
- Ensure feature folders exist under `lib/presentation/`

### Step 4: Commit Manifest Changes (optional)

```bash
git add lib/manifests/
git commit -m "chore(manifests): regenerate feature manifests"
```

### Success

Manifests are in `lib/manifests/`. Other commands (e.g. `/analyse`, `/add-feature`) can use them.
