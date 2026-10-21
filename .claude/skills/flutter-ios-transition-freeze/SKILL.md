---
name: flutter-ios-transition-freeze
description: Diagnose and fix iOS route-transition freezes, delayed taps, duplicate pushes, and screens that become unresponsive after back navigation. Use for freeze, stuck, phantom-tap, or stacked-route reports.
---

# Flutter iOS Transition Freeze

Treat "freeze after navigation" as a symptom, not a provider or animation
diagnosis. Collect runtime evidence before changing disposal, transitions, or
navigation semantics.

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, and the matching
`.claude/rules/*.md`. Verify routes in both
`lib/core/routing/app_route.dart` and `lib/core/routing/router.dart`; this
project uses path-based `AppRoute` values with `go` and `push`.

## Symptoms

| Symptom | Likely cause |
|---|---|
| Screen freezes after popping back, recovers on scroll | A rebuild scheduled with no frame (step 4A); otherwise a transition rendering stall |
| Taps during the freeze navigate later (phantom taps) | The first tap's push happened but no frame drew it (step 4A) |
| Multiple copies of the same screen stack | Navigation guard resets before the pushed route pops |
| A `Timer.periodic` widget keeps working under another route | The timer keeps firing while its route is covered |
| Provider refetch and rebuild storm on pop | A zero disposal delay cancels and refetches on every push/pop |

## 1. Establish a repeatable reproduction

Record the source route, destination route, push/pop sequence, device and iOS
version, build mode, first frame that stops responding, and whether queued taps
execute later. Reproduce on a physical iPhone in a profile or release build:
debug builds hide the step 4A freeze.

Before Flutter commands, run `command -v fvm` from the repository root. Prefix
the documented bare command only when FVM exists:

```bash
flutter run --profile --flavor dev -t lib/main_dev.dart
```

## 2. Separate Dart stalls from render/input stalls

Use Flutter DevTools frame and CPU timelines. Add a temporary low-frequency
heartbeat only when the timeline cannot distinguish the two:

- heartbeat and timers pause: investigate synchronous Dart work, provider
  recomputation, decoding, or loops on the UI isolate
- heartbeat continues while frames or taps stop: check for a rebuild scheduled
  with no frame first (step 4A), then transition rendering, platform views,
  overlays, pointer absorbers, and native logs

Split the interactions by whether they need a Flutter frame: platform-channel
actions (`launchUrl`, the native share sheet) still fire on a screen frozen by
step 4A while a push looks dead. That isolates the stall to Flutter rendering,
not iOS.

Remove all diagnostics before handoff.

## 3. Isolate the trigger

Reduce the affected route to a `Scaffold`, then restore one category at a time:

1. route/page transition
2. provider watches and listeners
3. hooks and lifecycle effects
4. overlays, gestures, and focus
5. child widgets, platform views, and periodic timers

The first category that restores the freeze defines the next experiment.

## 4. Apply the evidence-backed fix

### 4A. A rebuild scheduled with no frame

When a screen that `ref.watch`es or `ref.listen`s an auto-dispose provider
unmounts as its last listener, Riverpod schedules the provider's disposal.
`flutter_riverpod` 3.1.x did that by calling `setState` on `ProviderScope`
inside `BuildOwner.finalizeTree`. Debug builds reject the call and Riverpod
swallows the error, so they never freeze. Release and profile builds accept it,
but `ensureVisualUpdate` cannot request a frame during
`SchedulerPhase.persistentCallbacks`, so `BuildOwner` stays latched as "build
scheduled". Every later `setState`, a tap's GoRouter push included, marks
widgets dirty without asking for a frame. Touches arrive and timers run, but
nothing redraws until something requests a frame, such as a scroll.

`flutter_riverpod` 3.2.0 dropped that synchronous `setState`, and 3.3.2
schedules disposal through a microtask. A refresh still calls `setState`
synchronously (`scheduleRefresh` in `provider_scope.dart`), so a freeze of this
shape whose stack shows `scheduleRefresh` is that path; one whose stack shows
disposal means `flutter_riverpod` in `pubspec.lock` is below 3.3.2.

Evidence that points here:

- `ref.read()` on the same provider does not freeze (no listener, no disposal)
- `ref.watch()` or `ref.listen()` on it does; on a keepAlive provider it does not
- only release and profile builds freeze
- GoRouter's `currentConfiguration` already has the tapped route on top while
  `ModalRoute.of(context).isCurrent` is still true on the screen below

Confirm it in a profile build on a physical iPhone, reading `print` output
through `idevicesyslog`:

1. A global pointer route
   (`GestureBinding.instance.pointerRouter.addGlobalRoute`) logging each
   event's hit-test path. Touches arriving rules out iOS touch delivery.
2. A timer that walks the element tree from
   `WidgetsBinding.instance.rootElement` and reports elements with
   `dirty == true` while `!SchedulerBinding.instance.hasScheduledFrame` and the
   phase is `SchedulerPhase.idle`. Any hit is the stuck state.
3. A wrapper on `WidgetsBinding.instance.buildOwner!.onBuildScheduled` that
   prints `StackTrace.current` when the phase is
   `SchedulerPhase.persistentCallbacks`. The stack names the late `setState`.

Fix: keep `flutter_riverpod` at 3.3.2 or later, and remove the late
`setState` the stack names. Make a provider keepAlive only when its state
should outlive the screen, never as a freeze workaround. Drop an unnecessary
`async` from `build()` (`build() async => null`): it forces an
`AsyncLoading` → `AsyncData` transition, and an extra rebuild, on every
creation during the page transition.

### 4B. Provider lifecycle churn

Inspect disposal and recomputation in Riverpod logs. Use
`@Riverpod(keepAlive: true)` only when state must survive with no listeners.
Otherwise keep auto-disposal and clean up resources with `ref.onDispose`. When
traces show rapid dispose/refetch churn on push/pop, give the provider a grace
window, either with `ref.manageDataCaching(disposalTimerDuration: …)` from
`lib/core/extensions/provider_extensions.dart` or directly:

```dart
final link = ref.keepAlive();
final timer = Timer(const Duration(seconds: 3), link.close);
ref.onDispose(timer.cancel);
```

Do not add a manual reset or keepAlive as a speculative freeze fix.

### 4C. Transition rendering

If the frame timeline pins the transition, replace only the affected route's
page transition with `NoTransitionPage` or a lightweight
`CustomTransitionPage`, preserving its `AppRoute` path and back behavior.

### 4D. Navigation guards

Never reset a guard flag from a route listener: the router state it reads can
be stale when checked synchronously. Reset it from the `Future` that `push`
returns, which completes when the pushed route pops:

```dart
final isNavigating = useRef(false);

onTap: () {
  if (isNavigating.value) return;
  isNavigating.value = true;
  context.push(AppRoute.target).whenComplete(() => isNavigating.value = false);
},
```

### 4E. Periodic work

`Timer.periodic` is not ticker-based, so it keeps firing under a covering
route. Gate it on `TickerMode` and re-sync when the route becomes visible:

```dart
final remaining = useState(computeRemaining());
final isActive = TickerMode.of(context);

useEffect(() {
  if (!isActive) return null;
  remaining.value = computeRemaining();
  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    remaining.value = computeRemaining();
  });
  return timer.cancel;
}, [isActive]);
```

## 5. Verify the mechanism

Repeat the original rapid navigation sequence in profile mode, confirm taps are
not buffered, confirm one destination is pushed, and inspect the timeline for
the removed stall. Run focused tests and root `AGENTS.md` verification. Do not
claim an iOS compositor or provider-disposal root cause without matching trace
evidence.

```
- [ ] Reduced to a bare Scaffold and restored one category at a time
- [ ] Heartbeat separates a Dart stall from a render/input stall
- [ ] flutter_riverpod in pubspec.lock is 3.3.2 or later
- [ ] Stuck-frame probes run in a profile build; the late setState is named
- [ ] keepAlive only where state should outlive the screen
- [ ] Periodic timers on the screen are gated on TickerMode
- [ ] Navigation guards reset from the push Future, not a route listener
- [ ] Tested in profile mode on a physical iPhone
- [ ] No diagnostic code left in committed files
```
