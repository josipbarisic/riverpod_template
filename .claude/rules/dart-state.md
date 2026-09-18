---
paths:
  - "lib/**/*controller*.dart"
  - "lib/**/*provider*.dart"
  - "lib/**/*state*.dart"
  - "lib/core/utils/user_handler/*.dart"
---

# Riverpod State

The project uses Riverpod 3 and annotation-based code generation. New providers and notifiers must
use `@riverpod` or `@Riverpod`; do not declare manual `Provider`, `StateProvider`,
`FutureProvider`, `StreamProvider`, `NotifierProvider`, or `AsyncNotifierProvider` instances.

An annotated library imports `riverpod_annotation`, declares its generated part, and extends the
generated base when it owns mutable state:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ExampleController extends _$ExampleController {
  @override
  bool build() => false;
}
```

Use `@riverpod` for default auto-disposal. Use `@Riverpod(keepAlive: true)` only when the provider
must retain state with no listeners, such as an app-lifetime service or session owner. A provider
recomputation still disposes its previous state; register owned-resource cleanup with
`ref.onDispose`.

Riverpod 3 function providers receive the unified `Ref` type:

```dart
@riverpod
Future<User> userData(Ref ref, int id) =>
    ref.watch(userRepositoryProvider).fetchUserData(id);
```

## Ref access

- `ref.watch()` establishes a reactive dependency. Use it in provider `build()` methods and widget
  builds when a dependency change must recompute or rebuild.
- `ref.read()` is a non-reactive snapshot. Use it for imperative calls and callbacks.
- `ref.listen()` handles side effects such as navigation and messages; do not use it to derive
  render state.
- `ref.invalidate(provider)` discards the current state and lets Riverpod recompute according to
  demand. `ref.refresh(provider)` invalidates and immediately reads; use its returned value.

Do not cache a provider value in a field when it must stay reactive. Read the notifier for
commands and watch the provider for state.

## Async state

A generated notifier with a `Future` or `FutureOr` build result exposes `AsyncValue<T>`. Represent
work with `AsyncLoading`, success with `AsyncData`, and failures with `AsyncError`, preserving the
real stack trace. Guard async mutations so an older request cannot overwrite newer state when the
feature permits concurrent calls.

## State classes

The live source uses both Equatable state classes and Freezed models. Use Equatable for small
explicit states and Freezed when generated copy/serialization or a larger immutable shape is
useful. A dedicated state class is optional when `AsyncValue<T>` already expresses the complete
state.

After changing Riverpod, Freezed, or JSON-serializable annotations, follow root `AGENTS.md` for
code generation. Never edit generated Dart files.
