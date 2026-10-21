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

## Server-owned enums

An enum decoded from the server falls back instead of throwing on a value the app does not know:
`@JsonKey(unknownEnumValue: …)` on a generated field, or an `unknown` member with
`values.firstWhere(…, orElse: () => unknown)` in a hand-written parser. Keep null for "the payload
has no value" and `unknown` for "a value the app does not understand"; they drive different UI.

## Watched values and callback parameters

Never name a callback parameter the same as a watched provider value in the enclosing scope:

```dart
final page = ref.watch(bottomNavigationControllerProvider.select((s) => s.page));
onTap: (index) {
  final tapped = SelectedBottomNavigationPage.values[index];
  final isReTap = page == tapped; // a parameter named `page` would shadow the watched value
```

## Logging

Never log tokens, credentials, or user personal data, not even in an error message: log that the
step failed, not the value. A token never goes in a URL query (`?access_token=`): proxies and logs
keep URLs. A Dio `LogInterceptor` must not print auth headers or bodies that carry credentials.

## Removing a rendered element

When a rendered element or capability is deleted, delete in the same change everything that existed
only to serve it: state fields only it read, controllers or providers left without a consumer,
strings, helpers, mixins and extensions only it called, routes, tests, and any `useMemoized`
dependency that referenced them. Check references first; do not delete shared code because the
removed call site used it.

`flutter analyze` does not catch an unread state field, so nothing fails: the widget goes and the
field it fed survives in the constructor, `copyWith` and equality indefinitely.

## Scope

Make only the requested change. Do not fold unrelated cleanup, renames, dependency updates, or
generated-file churn into the task.
