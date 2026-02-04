# AI Agent Guide (Riverpod Template)

Quick reference for AI agents working on projects started from this template.

## Per-Feature Context (ZERO-DRIFT Pattern)

When working on a feature, read BOTH:

1. **`ARCHITECTURE.md`** (repo root) – Architecture, layers, conventions
2. **`lib/manifests/{feature}.manifest.generated.json`** – Technical specifics (auto-generated)

### Manifest Structure

Each manifest contains:

- **`exports`** – views, controllers, widgets, models, states, repositories
- **`routes`** – Navigation (AppRoute constant, path, view)
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
- **Never edit** `lib/manifests/*.manifest.generated.json` by hand. Change the generator or code, then regenerate.

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

```
lib/
├── core/                    # Shared infrastructure
│   ├── constants/           # App-wide constants
│   ├── enums/               # Enumerations
│   ├── extensions/          # Dart extensions
│   ├── mixins/              # Reusable mixins
│   ├── routing/             # GoRouter, AppRoute constants
│   ├── services/            # Core services (network, notifications)
│   ├── theme/               # Colors, text styles, theming
│   └── utils/               # Utilities, network config, shared prefs
├── data/                    # Data layer
│   ├── firebase/            # Firebase API
│   └── repositories/        # Repository implementations
├── models/                  # Domain models (Freezed)
├── presentation/            # UI by feature (views, controllers)
└── manifests/               # Auto-generated feature manifests
```

### Imports

**Always use absolute package imports:**

```dart
import 'package:riverpod_template/core/routing/app_route.dart';
import 'package:riverpod_template/core/services/network_service/network_service.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';
import 'package:riverpod_template/models/user/user.dart';
import 'package:riverpod_template/presentation/login/login_view.dart';
```

**Never:** relative imports (`../`, `./`), barrel exports.

### Routing

- **Route constants:** `lib/core/routing/app_route.dart` → `AppRoute.login`, `AppRoute.splash`, etc.
- **Route definitions:** `lib/core/routing/router.dart`
- **Navigation:** `context.go(AppRoute.login);`, `context.push(AppRoute.signUp);`

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
- **`/test`** – Create tests for features
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
- **Routes:** Use `AppRoute.xxx` only (no string literals)

---

## Testing Workflow

When modifying a feature:

1. **Check manifest** for `testing.hasTests`
2. **If tests exist**, run them before and after changes:
   ```bash
   flutter test test/presentation/{feature}/
   ```
3. **If adding new functionality**, add corresponding tests
4. **All tests must pass** before committing

Use the manifest's `testing.runCommand` for the exact command.

---

## Manifest Testing Section

Each manifest includes a `testing` object:

```json
{
  "testing": {
    "testDirectory": "test/presentation/login",
    "testFiles": ["test/presentation/login/login_controller_test.dart"],
    "testDataFiles": ["test/test_data/auth_test_data.dart"],
    "runCommand": "flutter test test/presentation/login",
    "hasTests": true
  }
}
```

| Field | Description |
|-------|-------------|
| `testDirectory` | Where tests for this feature live |
| `testFiles` | List of `*_test.dart` files |
| `testDataFiles` | Test data factories related to this feature |
| `runCommand` | Command to run feature tests |
| `hasTests` | Quick check if tests exist |

---

## Test Structure

```
test/
├── domain/
│   └── {model}_test.dart
├── presentation/
│   └── {feature}/
│       ├── {feature}_controller_test.dart
│       ├── {feature}_view_test.dart (widget tests)
│       └── mocks/
│           └── mock_{xxx}_repository.dart
├── repositories/
│   └── {repository}_test.dart
├── services/
│   └── {service}_test.dart
├── test_data/
│   └── {feature}_test_data.dart
└── helpers/
    └── test_helpers.dart
```

- **Domain tests**: `test/domain/` (model tests)
- **Controller tests**: `test/presentation/{feature}/`
- **Widget tests**: Same directory as controller tests
- **Mocks**: `test/presentation/{feature}/mocks/`
- **Test data**: `test/test_data/` (factories + constants)
- **Helpers**: `test/helpers/` (shared utilities)

---

## Mocking

### Strategy

- **Mock repositories**, not controllers
- Use **mocktail** for mocks
- Use **ProviderContainer** with overrides for Riverpod testing

### Mock Pattern

```dart
// test/presentation/login/mocks/mock_auth_repository.dart
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  void stubLoginSuccess(User user) {
    when(() => login(any(), any())).thenAnswer((_) async => user);
  }

  void stubLoginError(Exception error) {
    when(() => login(any(), any())).thenThrow(error);
  }
}
```

### Controller Test Pattern

```dart
void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('login success updates state', () async {
    final testUser = TestUsers.basic;
    mockAuthRepository.stubLoginSuccess(testUser);

    final controller = container.read(loginControllerProvider.notifier);
    await controller.login('email', 'password');

    final state = container.read(loginControllerProvider);
    expect(state.value?.user, equals(testUser));
  });
}
```

---

## Testing Requirements (MANDATORY)

### Before Every Commit

```bash
flutter test
```

All tests must pass. **Never commit with failing tests.**

### What to Test

| If You Modified... | Update Test In... |
|-------------------|-------------------|
| Controller logic | `test/presentation/{feature}/{feature}_controller_test.dart` |
| Repository method | `test/repositories/{repository}_test.dart` |
| Model/domain | `test/domain/{model}_test.dart` |
| Widget behavior | `test/presentation/{feature}/{feature}_view_test.dart` |
| New API endpoint | Add repository test with mock network response |

### Test Data Patterns

Use factory functions in `test/test_data/`:

```dart
// test/test_data/auth_test_data.dart
User createTestUser({
  String? id,
  String? email,
  String? name,
}) => User(
  id: id ?? 'test-id',
  email: email ?? 'test@example.com',
  name: name ?? 'Test User',
);

class TestUsers {
  static User get basic => createTestUser();
  static User get admin => createTestUser(name: 'Admin', email: 'admin@example.com');
}
```
