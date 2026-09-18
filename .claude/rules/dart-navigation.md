---
paths:
  - "lib/core/routing/**/*.dart"
  - "lib/core/utils/helpers/deeplink_helper.dart"
  - "lib/presentation/**/*.dart"
---

# Navigation

`lib/core/routing/app_route.dart` defines `AppRoute` path constants.
`lib/core/routing/router.dart` registers `GoRoute` definitions.

The current router uses path-based routes, not named routes. Navigate with the `AppRoute` value:

```dart
context.go(AppRoute.login);
context.push(AppRoute.signUp);
context.pop();
```

`GoRouter.of(context).go(AppRoute.onboarding)` is the equivalent explicit form. Do not pass raw
route strings from call sites, and do not use `goNamed` or `pushNamed` unless the corresponding
`GoRoute` first gains a `name`.

The project extension for clearing the stack is defined on `GoRouter`:

```dart
GoRouter.of(context).pushAndRemoveUntil(AppRoute.login);
```

When adding, renaming, or removing a route:

1. Update the path constant in `app_route.dart`.
2. Update its `GoRoute` in `router.dart`.
3. Update navigation and deeplink call sites.
4. Regenerate feature manifests.
5. Add or update navigation tests when behavior changes.

Do not infer route availability from a manifest or document; verify both routing source files.
