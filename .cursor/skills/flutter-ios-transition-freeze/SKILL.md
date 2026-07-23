---
name: flutter-ios-transition-freeze
description: Diagnose and fix iOS screen freezes after route transitions, buffered/phantom taps, and navigation guard failures. Use when QA reports a screen freeze after navigating back, taps not registering, multiple screens stacking, or when the user mentions "freeze", "stuck", "unresponsive after back", or "phantom taps".
---

# Flutter iOS Transition Freeze

Systematic workflow for diagnosing and fixing the class of bugs where an iOS screen appears frozen
or unresponsive after a route transition (push/pop), taps are buffered and fire later, or duplicate
screens stack on the navigation stack.

## Symptoms

| Symptom                                               | Likely Cause                                                       |
|-------------------------------------------------------|--------------------------------------------------------------------|
| Screen freezes after popping back, recovers on scroll | Auto-dispose provider disposal during page transition (see Step 2C)|
| Screen freezes after popping back, recovers on scroll | Native iOS rendering stall from route transition animation         |
| Taps during freeze navigate later (phantom taps)      | iOS touch event buffering during native `UIView` stall             |
| Multiple copies of the same screen stack              | Navigation guard resets too early (before pop)                     |
| `Timer.periodic` widget freezes on underlying screen  | Timer keeps firing while route is obscured                         |
| Provider refetch + rebuild storm on pop               | Zero-duration disposal timer causes cancel+refetch cycle           |

## Diagnostic Workflow

### Step 0: Binary Search Isolation (RECOMMENDED FIRST)

Before adding instrumentation, use binary search to isolate the culprit. This is faster and more
reliable than guessing.

**Method:** Strip the freezing screen to a bare `Scaffold`, confirm no freeze, then add components
back one at a time:

1. Replace the target view with a bare `StatelessWidget` + `Scaffold` (no providers, no hooks)
2. If freeze stops → the issue is in the view content, not routing
3. Add back your scaffold wrapper
4. Add back Riverpod providers one at a time (`ref.watch`, `ref.read`, `ref.listen`)
5. Add back hooks (`useState`, `useEffect`)
6. Add back child widgets (selectors, buttons, etc.)

The step where the freeze returns is your culprit. This eliminates entire categories of causes
in minutes rather than hours of log analysis.

### Step 1: Confirm Dart Event Loop Is NOT Blocked

Add a heartbeat timer to the freezing screen's `build` method:

```dart
import 'dart:async';
import 'dart:developer';

// Inside HookConsumerWidget.build():
useEffect(() {
  var tick = 0;
  final heartbeat = Timer.periodic(const Duration(milliseconds: 500), (_) {
    log('HEARTBEAT #${++tick} t=${DateTime.now().millisecondsSinceEpoch}');
  });
  return heartbeat.cancel;
}, const []);
```

**Run in profile mode** (`flutter run --profile --flavor dev -t lib/main_dev.dart`) and
reproduce the freeze.

- **Heartbeats continue during freeze** -> Native rendering/touch delivery problem (Step 2A)
- **Heartbeats pause during freeze** -> Dart-side blockage (Step 2B)

### Step 2A: Native Rendering Stall

The iOS compositor stalls during or just after the route transition animation completes. The Dart
isolate keeps running but the native `UIView` layer stops accepting touch events and repainting
until a forced layout pass (e.g. scroll gesture).

**Fix: Remove the transition animation**

In `lib/core/routing/router.dart`, change the route from `builder` to `pageBuilder` with
`NoTransitionPage`:

```dart
// BEFORE
GoRoute(
  name: AppRoute.someRoute,
  path: AppRoute.someRoute,
  builder: (context, state) => const SomeView(),
),

// AFTER
GoRoute(
  name: AppRoute.someRoute,
  path: AppRoute.someRoute,
  pageBuilder: (context, state) => NoTransitionPage<void>(
    key: state.pageKey,
    child: const SomeView(),
  ),
),
```

If a transition animation is required for UX, try `CustomTransitionPage` with a lightweight fade
instead of the default iOS slide:

```dart
pageBuilder: (context, state) => CustomTransitionPage<void>(
  key: state.pageKey,
  child: const SomeView(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      FadeTransition(opacity: animation, child: child),
  transitionDuration: const Duration(milliseconds: 200),
),
```

### Step 2B: Dart-Side Blockage

If heartbeats pause, the Dart isolate is blocked. Common causes:

1. **Synchronous work in `build()`** — auth token fetch, heavy JSON parsing
2. **Provider cascade** — Invalidating a provider triggers a chain of rebuilds
3. **Expensive `Timer.periodic` callbacks** — Multiple timers firing simultaneously

Profile with DevTools timeline to find the bottleneck.

### Step 2C: Auto-Dispose Provider Disposal During Page Transition (MOST COMMON)

**Root cause:** `ref.watch()` or `ref.listen()` on an auto-dispose (`@riverpod`) AsyncNotifier
provider creates a listener that keeps the provider alive for the widget's lifetime. When the widget
is disposed during back navigation, the listener is removed and the auto-dispose provider is
destroyed. This disposal during the page transition stalls the iOS frame pipeline, causing taps to
be unresponsive until a drag gesture forces a layout pass.

**Key diagnostic evidence:**
- `ref.read()` on the same provider does NOT freeze (no active listener → no disposal during transition)
- `ref.watch()` on the same provider DOES freeze (listener disposed during transition)
- `ref.listen()` on the same provider DOES freeze (same reason)
- `ref.watch()` on a `keepAlive` provider does NOT freeze (never disposed)

**Fix: Make the provider `keepAlive` and add a manual reset:**

```dart
// BEFORE — auto-dispose, causes freeze on rapid navigation
@riverpod
class SomeController extends _$SomeController {
  @override
  FutureOr<SomeModel?> build() async => null;
}

// AFTER — keepAlive, no disposal during transitions
@Riverpod(keepAlive: true)
class SomeController extends _$SomeController {
  @override
  FutureOr<SomeModel?> build() => null; // synchronous when possible

  /// Resets state to initial — required because keepAlive retains stale state.
  void reset() => state = const AsyncData(null);
}
```

In the view, reset on mount (deferred to avoid modifying provider during build):

```dart
useEffect(() {
  Future(controller.reset);
  return null;
}, const []);
```

**Why this works:** The provider is never disposed during page transitions, so the iOS frame
pipeline is never stalled. The `reset()` call on mount ensures fresh state for each screen visit.

**Also note:** If the provider's `build()` method uses `async` unnecessarily (e.g., `build() async => null`),
remove the `async` keyword. An `async` build forces an `AsyncLoading` → `AsyncData` state transition
on every provider creation, which triggers an extra widget rebuild during the page transition.

### Step 3: Fix Timer.periodic Widgets

Any widget using `Timer.periodic` (countdowns, polling, animations) must pause when its route is
obscured. Flutter disables `TickerMode` for underlying routes but `Timer.periodic` is not
Ticker-based.

```dart
@override
Widget build(BuildContext context) {
  final remaining = useState(_computeRemaining());
  final isActive = TickerMode.of(context);

  useEffect(() {
    if (!isActive) return null;

    remaining.value = _computeRemaining();
    final timer = Timer.periodic(const Duration(seconds: 1), (_) {
      remaining.value = _computeRemaining();
    });
    return timer.cancel;
  }, [deadline, isActive]);

  // ... render using remaining.value
}
```

**Key points:**

- `TickerMode.of(context)` returns `false` when the route is under another route
- Add `isActive` to the `useEffect` dependency list so it re-runs on route visibility change
- Sync the value immediately on un-pause so the display is correct

### Step 4: Fix Navigation Guards

Never reset a navigation guard flag by listening to route changes. The route state can be stale when
checked synchronously. Instead, tie the guard to the `Future` returned by `context.pushNamed`:

```dart
// WRONG — resets prematurely, allows duplicate pushes
useEffect(() {
  void handleRouteChange() {
    if (routeObserver.currentRoute != AppRoute.target) {
      isNavigating.value = false;
    }
  }
  router.routerDelegate.addListener(handleRouteChange);
  return () => router.routerDelegate.removeListener(handleRouteChange);
}, const []);

onTap: () {
  if (isNavigating.value) return;
  isNavigating.value = true;
  context.pushNamed(AppRoute.target);
}

// RIGHT — resets only when the pushed screen is actually popped
onTap: () {
  if (isNavigating.value) return;
  isNavigating.value = true;
  context.pushNamed(AppRoute.target).then((_) {
    isNavigating.value = false;
  });
}
```

Use `useRef<bool>(false)` for the flag to avoid unnecessary rebuilds.

**Alternative (GoRouter declarative):** Use `context.goNamed()` instead of `context.pushNamed()`.
This eliminates the need for navigation guards entirely since GoRouter manages the page stack
declaratively. However, this changes back-navigation behavior (pop vs. go-back).

### Step 5: Tune Provider Disposal Timers

When a route is pushed, providers watched only by the underlying screen lose their listeners. If a
provider is disposed immediately (zero-duration disposal), it must refetch when the screen regains
focus — causing a rebuild storm on pop. Keep the provider alive for a short grace window instead:

```dart
@riverpod
Future<SomeModel> someData(Ref ref) async {
  // Hold the provider for a few seconds after its last listener is removed,
  // so a quick push/pop cycle reuses the cached value instead of refetching.
  final link = ref.keepAlive();
  final timer = Timer(const Duration(seconds: 3), link.close);
  ref.onDispose(timer.cancel);

  return ref.watch(repositoryProvider).fetchSomeData();
}
```

A 3-second window is enough for most push/pop cycles without keeping stale data alive too long.
Adjust per use case.

## Checklist

When fixing a freeze-after-transition bug:

```
- [ ] Binary search isolation performed (bare Scaffold → add components back)
- [ ] Heartbeat test confirms native stall (not Dart blockage)
- [ ] Auto-dispose providers checked (ref.watch on auto-dispose = likely culprit)
- [ ] Provider changed to keepAlive with manual reset if auto-dispose was the cause
- [ ] Route uses appropriate transition (NoTransitionPage or lightweight if needed)
- [ ] All Timer.periodic widgets on the screen use TickerMode guard
- [ ] Navigation guards use Future-based reset (not route listeners) or goNamed
- [ ] Provider disposal grace window is >= 3s for push/pop-heavy screens
- [ ] Tested in profile mode on physical iOS device
- [ ] No diagnostic code left in committed files
```
