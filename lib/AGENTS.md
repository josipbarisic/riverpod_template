# AI Agent Guide (Riverpod Template)

Quick reference for AI agents working on projects started from this template.

## Per-Feature Context (ZERO-DRIFT Pattern)

When working on a feature, read BOTH:

1. **`ARCHITECTURE.md`** (repo root) – Architecture, layers, conventions
2. **`lib/manifests/{feature}/{feature}.manifest.generated.json`** – Technical specifics (auto-generated)

### Manifest Structure

Each manifest contains:

- **`exports`** – views, controllers, widgets, models, states, repositories
- **`routes`** – Navigation (RoutePath constant, path, view)
- **`providers`** – Riverpod provider definitions
- **`stateClasses`** – State classes and fields
- **`controllerMethods`** – Controller method signatures
- **`apiEndpoints`** – API endpoints and usage
- **`dependencies`** – Other areas this feature depends on

### When the manifest looks wrong

- **Stale:** If any file in `exports` is newer than `generatedAt`, regenerate:
  ```bash
  dart run scripts/generate_feature_manifests.dart
  ```
- **Never edit** `lib/manifests/**/*.manifest.generated.json` by hand. Change the generator or code, then regenerate.

### Feature areas (template)

- **`splash`** – App initialization
- **`onboarding`** – Onboarding flow
- **`login`** – Login screen
- **`sign_up`** – Sign up flow
- **`bottom_navigation`** – Main shell / tabs
- **`home`** – Home tab content

Manifests: `lib/manifests/splash.manifest.generated.json`, `lib/manifests/login.manifest.generated.json`, etc.

---

## Architecture Overview

### Layers

- **`lib/presentation/`** – Views, controllers, widgets (by feature)
- **`lib/data/repositories/`** – Repository implementations
- **`lib/domain/`** – Domain models (Freezed)
- **`lib/routing/`** – GoRouter, RoutePath constants
- **`lib/services/`** – Core services
- **`lib/theme/`**, **`lib/utils/`** – Theme, helpers, network

### Imports

**Always use absolute package imports:**

```dart
import 'package:riverpod_template/presentation/login/login_view.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';
```

**Never:** relative imports (`../`, `./`), barrel exports.

### Routing

- **Route constants:** `lib/routing/router.dart` → `RoutePath.login`, `RoutePath.splash`, etc.
- **Navigation:** `context.go(RoutePath.login);`, `context.push(RoutePath.signUp);`

---

## Code Generation

```bash
# After @riverpod / @freezed changes
dart run build_runner build -d

# After structural changes (new features, routes)
dart run scripts/generate_feature_manifests.dart
```

---

## Cursor Commands

Type `/` in Cursor Chat:

- **`/add-feature`** – Add a new feature/screen (complexity Tier 1/2/3)
- **`/fix-bug`** – Fix bugs with manifest context
- **`/review`** – Pre-commit review
- **`/commit`** – Secure, atomic commits
- **`/regenerate-manifests`** – Regenerate manifests
- **`/analyse`** – Analyse a feature (manifest-based report)

See `.cursor/commands/README.md` for details.

---

## Complexity & Discovery

- **Tier 1 – Quick:** Single file, small change → minimal discovery → execute
- **Tier 2 – Moderate:** A few files → short discovery + plan → execute
- **Tier 3 – Large:** New feature or big change → full discovery + spec + plan → **wait for approval** → implement

Full scale: `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`

---

## Key Patterns

- **State:** `@riverpod`, `@freezed`, `AsyncValue`
- **Widgets:** `ConsumerWidget` / `HookConsumerWidget`; no private `_build*` methods (extract to separate widget files)
- **Routes:** Use `RoutePath.xxx` only (no string literals)
