# Riverpod Template – Architecture

This document defines the architecture and conventions for projects started from this template. It is intended for both humans and AI agents (see `lib/AGENTS.md` for a quick reference).

---

## Principles

1. **Layer-based structure** – Presentation, data, models, and core (routing, services, theme, utils) are clearly separated.
2. **Feature-grouped presentation** – Under `lib/presentation/`, code is organized by feature (splash, login, home, etc.).
3. **Absolute imports** – All imports use `package:riverpod_template/...`. No relative imports or barrel exports.
4. **Code generation first** – Riverpod providers and Freezed models use code generation; generated files are not edited by hand.
5. **AI-first from the start** – Feature manifests, Cursor rules, and commands are part of the template so every new project gets the same AI workflow.

---

## Directory Structure

```
lib/
├── core/                           # Shared infrastructure
│   ├── config/                     # App configuration
│   │   └── auth_config.dart        # Modular auth provider toggles
│   ├── constants/                  # App-wide constants
│   │   └── state_errors.dart       # Typed AsyncError constants
│   ├── enums/                      # Enumerations
│   │   ├── sign_in_provider_enum.dart     # Auth provider IDs (email, google, apple, phone)
│   │   └── registration_step_enum.dart    # Multi-step registration tracking
│   ├── extensions/                 # Dart extensions
│   ├── mixins/                     # Reusable mixins
│   │   ├── snackbar_mixin.dart     # Snackbar display
│   │   └── dialog_mixin.dart       # Confirmation dialogs
│   ├── routing/                    # GoRouter configuration
│   │   ├── app_route.dart          # AppRoute class with route name constants
│   │   ├── router.dart             # GoRouter configuration and route definitions
│   │   └── page_transitions.dart   # Custom page transitions (Reveal, ModalRise, GentleFade)
│   ├── services/                   # Core services
│   │   ├── language_service/       # Remote translations service
│   │   ├── local_notifications_service/
│   │   └── network_service/
│   ├── theme/                      # Colors, text styles, theming
│   └── utils/                      # Utilities and helpers
│       ├── helpers/
│       │   ├── firebase_error_helper.dart    # Firebase error message extraction
│       │   ├── deeplink_helper.dart          # Deeplink parsing, auth-gated navigation
│       │   └── screenshot_detection_hook.dart # Screenshot detection hook
│       ├── input_formatters/
│       │   └── phone_number_formatter.dart   # E.164 / US phone formatting
│       ├── user_handler/
│       │   └── user_handler.dart             # Global user state (Riverpod keepAlive)
│       ├── network/                # Network config, endpoints, interceptors
│       ├── notifications/          # Notification utilities
│       └── shared_prefs/           # SharedPreferences utilities
│
├── data/                           # Data layer
│   ├── firebase/                   # Firebase API (auth, messaging)
│   └── repositories/               # Repository implementations
│       ├── auth_repository/        # Auth (email, social, phone, password reset, sign out)
│       └── user_repository/        # User CRUD (fetch, update with UserHandler)
│
├── models/                         # Domain models (Freezed)
│   ├── user/                       # User model with extended profile fields
│   ├── product/
│   ├── order/
│   └── ...
│
├── presentation/                   # UI by feature
│   ├── splash/
│   ├── onboarding/
│   ├── login/                      # Login + forgot password + email/phone verification
│   ├── sign_up/                    # Registration with modular step flow
│   ├── profile/                    # Profile viewing and editing
│   ├── bottom_navigation/
│   ├── home/
│   └── widgets/                    # Shared presentation widgets
│
└── manifests/                      # Auto-generated feature manifests (for AI)
    ├── splash.manifest.generated.json
    ├── login.manifest.generated.json
    └── ...
```

---

## Layer Responsibilities

### Core Layer (`lib/core/`)

**Purpose**: Shared infrastructure used across the entire application.

**Contents**:

- **Constants**: App-wide constants (e.g., `network_constants.dart`)
- **Enums**: Enumerations (e.g., `order_status_enum.dart`)
- **Extensions**: Dart extensions (e.g., `theme_extensions.dart`)
- **Mixins**: Reusable mixins (e.g., `snackbar_mixin.dart`)
- **Routing**: GoRouter configuration
    - **Route Constants**: `AppRoute` class in `lib/core/routing/app_route.dart`
    - **Route Definitions**: GoRouter config in `lib/core/routing/router.dart`
- **Services**: Network, notifications, etc.
- **Theme**: Colors, text styles, app theming
- **Utils**: Helper functions, network config, shared preferences

**Rules**:

- Core code should be feature-agnostic
- If code is specific to one feature, it belongs in that feature's presentation group

### Data Layer (`lib/data/`)

**Purpose**: Data access, API communication, and external service integration.

**Contents**:

- **Repositories**: Implement business logic for data operations
- **Repository Interfaces**: Define contracts for repositories
- **Repository Providers**: Riverpod providers for dependency injection
- **Firebase API**: Firebase-specific integration code

**Pattern**:

```
repositories/{name}_repository/
├── {name}_repository.dart              # Implementation
├── {name}_repository_interface.dart    # Interface/contract
└── {name}_repository_providers.dart    # Riverpod providers
```

### Models Layer (`lib/models/`)

**Purpose**: Business entities and domain models.

**Contents**:

- **Freezed Models**: Immutable data classes with code generation
- **Business Entities**: Core domain concepts (User, Product, Order, etc.)

**Rules**:

- All models use `@freezed` for immutability
- Models are pure data structures (no business logic)
- Models are organized by domain concept

### Presentation Layer (`lib/presentation/`)

**Purpose**: UI components, user interactions, and presentation logic.

**Organization**: Grouped by feature (splash, login, home, etc.).

**Contents**:

- **Views** (`*_view.dart`): Screen widgets
- **Controllers** (`*_controller.dart`): Business logic and state management
- **States** (`*_state.dart`): State classes (Freezed or Equatable)
- **Widgets** (`widgets/`): Reusable UI components

---

## Routing

### Route Constants

Route name constants are defined in `lib/core/routing/app_route.dart`:

```dart
class AppRoute {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String bottomNavigation = '/bottomNavigation';
}
```

### Navigation Patterns

**Navigate to a route:**

```dart
context.go(AppRoute.login);
context.push(AppRoute.signUp);
```

**Navigate back:**

```dart
context.pop();
```

**Adding a route:**

1. Add constant to `AppRoute` class in `lib/core/routing/app_route.dart`
2. Add `GoRoute` definition in `lib/core/routing/router.dart`

---

## State Management

- **Riverpod** with code generation (`@riverpod`)
- **Freezed** for immutable state and models
- **AsyncValue** for async operations in UI (loading, data, error)

---

## Controller Testability

Controllers must be designed for easy testing:

### Rule: Depend on Riverpod Only

Controllers obtain dependencies via **Riverpod** (`ref.read(xxxRepositoryProvider)`), never by direct instantiation.

```dart
// ✅ CORRECT - Testable
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<LoginState> build() => const LoginState();

  Future<void> login(String email, String password) async {
    // Get repository via Riverpod - can be overridden in tests
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signInWithEmailAndPassword(email, password);
    // ...
  }
}

// ❌ WRONG - Not testable
class LoginController {
  final _authRepo = AuthRepository(); // Direct instantiation, can't mock in tests
}
```

### Testing Pattern

In tests, you override the provider with a mock:

```dart
container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(mockAuthRepository),
  ],
);
```

---

## Widget Rules

- Use `ConsumerWidget`, `HookWidget`, or `HookConsumerWidget` as appropriate
- Do not define private widget-building methods (e.g. `Widget _buildBody()`) in the same file
- Extract to a separate widget class in its own file
- One widget class per file

---

## Import Rules

### ✅ Correct Imports

**Always use absolute package imports:**

```dart
// Core layer
import 'package:riverpod_template/core/routing/app_route.dart';
import 'package:riverpod_template/core/services/network_service/network_service.dart';
import 'package:riverpod_template/core/theme/colors/light_app_colors.dart';

// Data layer
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';

// Models layer
import 'package:riverpod_template/models/user/user.dart';

// Presentation layer
import 'package:riverpod_template/presentation/login/login_view.dart';
```

### ❌ Prohibited Imports

**Never use relative imports:**

```dart
// ❌ WRONG
import '../widgets/custom_dialog.dart';
import '../../core/routing/router.dart';
```

---

## Feature Manifests

- **Location:** `lib/manifests/{feature}.manifest.generated.json`
- **Generated by:** `dart run scripts/generate_feature_manifests.dart`
- **When to regenerate:** After adding or moving views, controllers, routes, or repositories
- **Purpose:** Give AI agents (and developers) an up-to-date, machine-readable view of each feature's structure

Do not edit manifest JSON files by hand. Change the code or the generator script, then regenerate.

---

## Code Generation

```bash
# After changing @riverpod or @freezed
dart run build_runner build -d

# After changing structure (features, routes)
dart run scripts/generate_feature_manifests.dart
```

---

## Authentication & User Management

### Modular Auth Configuration

Auth providers are controlled by `lib/core/config/auth_config.dart`:

```dart
class AuthConfig {
  static const bool enableEmailAuth = true;
  static const bool enablePhoneAuth = true;
  static const bool enableGoogleAuth = true;
  static const bool enableAppleAuth = true;
  static const bool enableFacebookAuth = false;

  static const bool enableForgotPassword = true;
  static const bool requireEmailVerification = false;
  static const bool requirePhoneVerification = false;
  static const bool requireProfileCompletion = true;
}
```

Toggle flags to `true`/`false` to enable/disable providers and registration steps. The `LoginController` and `RegistrationController` respect these flags automatically.

### Auth Flow

```
LoginController.onSubmit(provider)
  ├── checks AuthConfig.isProviderEnabled()
  ├── routes to continueWithGoogle/Apple/Email/Phone
  └── sets LoginState(isAuthSuccess: true) on success

RegistrationController
  ├── determines next step from AuthConfig (skips disabled steps)
  ├── createAccountWithEmail() / createAccountWithSocial()
  └── advanceToNextStep() → verifyEmail → verifyPhone → completeProfile → completed
```

### User State

`UserHandler` (`@Riverpod(keepAlive: true)`) holds the current `User?` globally. Both `AuthRepository` and `UserRepository` update it automatically on successful operations. Access from any widget via:

```dart
final user = ref.watch(userHandlerProvider);
```

### Key Controllers

| Controller | Purpose | Location |
|-----------|---------|----------|
| `LoginController` | All sign-in providers, respects AuthConfig | `lib/presentation/login/` |
| `ForgotPasswordController` | Password reset emails | `lib/presentation/login/` |
| `EmailVerificationController` | Send/verify email | `lib/presentation/login/` |
| `PhoneVerificationController` | Send/verify SMS | `lib/presentation/login/` |
| `RegistrationController` | Modular multi-step registration | `lib/presentation/sign_up/` |
| `ProfileController` | View/edit user profile | `lib/presentation/profile/` |

### Utilities

| Utility | Purpose | Location |
|---------|---------|----------|
| `FirebaseErrorHelper` | User-friendly Firebase error messages | `lib/core/utils/helpers/` |
| `DeeplinkHelper` | Parse deeplinks, auth-gated navigation, pending storage | `lib/core/utils/helpers/` |
| `PhoneNumberFormatter` | E.164 and US display formatting | `lib/core/utils/input_formatters/` |
| `InputValidator` | Email, password, confirm password, required fields | `lib/core/utils/` |
| `DialogMixin` | Confirmation dialogs | `lib/core/mixins/` |
| `ScreenshotDetectionHook` | Detect screenshots in sensitive screens | `lib/core/utils/helpers/` |
| `LanguageService` | Remote translation fetching | `lib/core/services/language_service/` |
| `PageTransitions` | RevealTransition, ModalRiseTransition, GentleFadeTransition | `lib/core/routing/` |

---

## AI-First Setup (included in template)

- **Rules:** `.cursor/rules/*.mdc` – Project context, workflow, discovery, Dart conventions
- **Commands:** `.cursor/commands/*.md` – Slash commands (add-feature, fix-bug, review, commit, test, analyse)
- **Skills:** `.cursor/skills/` – Specialized agent skills
- **Docs:** `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md` – Complexity tiers and discovery-first workflow
- **Agent entry point:** `lib/AGENTS.md` – Quick reference for AI agents

When you create a new project from this template, rename the package (e.g. from `riverpod_template` to your app name) and update references in rules, commands, and AGENTS.md. Then run the manifest generator again so manifests reflect your package name and structure.

---

## Summary

Riverpod Template uses **Clean Architecture** with:

- **Layer-based structure**: Clear separation of concerns (core, data, models, presentation)
- **Grouped presentation layer**: Organized by feature
- **Direct imports**: Absolute package paths, no barrel exports
- **Riverpod state management**: Code-generated providers
- **Freezed models**: Immutable domain entities
- **Modular auth**: Configurable providers (email, phone, Google, Apple) with toggleable registration steps

This architecture provides:

- Clear separation of concerns
- Easy navigation and discovery
- Maintainable and scalable codebase
- Consistent patterns throughout
- Production-ready auth flows out of the box
