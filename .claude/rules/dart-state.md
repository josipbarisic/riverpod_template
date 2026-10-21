---
paths:
  - "lib/**/*controller*.dart"
  - "lib/**/*provider*.dart"
  - "lib/**/*state*.dart"
  - "lib/core/utils/user_handler/*.dart"
  - "lib/presentation/**/*.dart"
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

A keepAlive provider that holds one user's data watches `userHandlerProvider` in `build()` and
returns an empty value when the user is null. Otherwise it outlives sign-out and shows the previous
account's data after the next sign-in.

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

Reading it:

- There is no `valueOrNull` in Riverpod 3; `.value` is the nullable accessor.
- `AsyncLoading` keeps the previous error, so a retry in flight is `isLoading && hasError`. Gate
  failure UI on `hasError && !isLoading`, and read `value` or `requireValue` only after both checks;
  `requireValue` on an `AsyncError` throws and swallows the error UI.
- On a reload (a watched dependency changed, or the notifier set `AsyncLoading` itself), `when`
  shows `loading` even while an error is held; `ref.refresh` and `ref.invalidate` skip loading by
  default. Pass `skipLoadingOnReload: true` when the error or retry surface must stay up.

## State classes

Pick the smallest shape that holds the state:

1. **No state class** when `build()` can return the value itself (`FutureOr<List<T>>`,
   `FutureOr<bool>`) and the UI reads it as `AsyncValue<T>`.
2. **`@freezed`** for every new state class. It generates `copyWith`, `==` and `hashCode`, so a new
   field cannot be left out of equality the way it can from a hand-written `props` list.

```dart
@freezed
abstract class ExampleState with _$ExampleState {
  const factory ExampleState({
    @Default([]) List<String> items,
    @Default(false) bool isLoadingMore,
  }) = _ExampleState;
}
```

`LoginState` and `BottomNavigationState` are Equatable and stay until their files change for another
reason. Do not copy that shape into new code.

After changing Riverpod, Freezed, or JSON-serializable annotations, follow root `AGENTS.md` for
code generation. Never edit generated Dart files.
