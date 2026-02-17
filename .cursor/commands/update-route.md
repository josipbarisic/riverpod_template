---
description: Add or update a route in the app
---

## Update Route

Add or modify a route using the AppRoute pattern.

### Step 1: Gather Route Information

From user if needed:

- Route name (e.g. `profileSettings`, `notifications`).
- Path (often same as name, e.g. `/profileSettings`).
- Which view to display.
- Any route parameters.

### Step 2: Mandatory Reads

1. Read routing section in `lib/AGENTS.md` (or `ARCHITECTURE.md` if present).
2. Read `lib/core/routing/app_route.dart`.
3. Read `lib/core/routing/router.dart`.

### Step 3: State What You Read

List: AGENTS/ARCHITECTURE, app_route.dart, router.dart.

### Step 4: Plan

- Name, path, view, and (if nested) parent route.
- Add constant in `app_route.dart`: `static const String {routeName} = '{routeName}';`
- Add `GoRoute` in `router.dart` (or under parent’s `routes` if nested).

### Step 5: Implement

- Add constant to `lib/core/routing/app_route.dart`.
- Add route to `lib/core/routing/router.dart` (e.g. `GoRoute(name: AppRoute.{routeName}, path: '/{routeName}', builder: (context, state) => const {ViewName}(), ...)`).
- Use absolute imports; follow existing style in the file.

### Step 6: Regenerate Manifests

```bash
dart run scripts/generate_feature_manifests.dart
```

### Step 7: Verify

```bash
flutter analyze
```

### Step 8: Report

Summarize: route constant, path, view, files modified, manifests regenerated, analyze ✓.
