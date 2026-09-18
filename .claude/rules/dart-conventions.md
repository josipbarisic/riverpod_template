---
paths:
  - "lib/**/*.dart"
---

# Dart Conventions

## Imports

Use direct absolute package imports for project code:

```dart
import 'package:riverpod_template/core/routing/app_route.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';
import 'package:riverpod_template/models/user/user.dart';
import 'package:riverpod_template/presentation/login/login_view.dart';
```

Do not use `../` or `./` imports, and do not create barrel exports.

Order imports as Dart SDK, Flutter, third-party packages, then
`package:riverpod_template/...`, with a blank line between groups.

## Naming

| Type | Convention | Example |
|---|---|---|
| Files | `snake_case` | `login_controller.dart` |
| Classes and enums | `PascalCase` | `LoginController`, `SignInProvider` |
| Variables and methods | `camelCase` | `userName`, `fetchUserData()` |
| Constants | `lowerCamelCase` | `AppRoute.login`, `NetworkConstants.baseUrl` |
| Private members | `_` prefix | `_authRepository`, `_handleSubmit()` |

Generated Riverpod providers keep generator-derived names: a
`ProfileController` produces `profileControllerProvider`; a repository
function named `userRepository` produces `userRepositoryProvider`.

## Expression bodies

Use `=>` when a function, getter, or method consists only of one returned expression:

```dart
String get fullName => '$firstName $lastName';

@override
Widget build(BuildContext context) => const SizedBox.shrink();
```

Use a block when the body has multiple statements, local variables, control flow, or needs
comments that explain the mechanism.

## Removal completeness

When removing a rendered element or capability, remove state fields, providers, helpers, imports,
tests, and routes that existed only for it. Check references first; do not delete shared code
because it was used by the removed call site.

## Scope

Make only the requested change. Do not fold unrelated cleanup, renames, dependency updates, or
generated-file churn into the task.
