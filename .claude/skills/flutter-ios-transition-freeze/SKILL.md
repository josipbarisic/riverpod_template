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

## 1. Establish a repeatable reproduction

Record the source route, destination route, push/pop sequence, device and iOS
version, build mode, first frame that stops responding, and whether queued taps
execute later. Reproduce on a physical iPhone when possible.

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
- heartbeat continues while frames or taps stop: inspect transition rendering,
  platform views, overlays, pointer absorbers, and native logs

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

### Provider lifecycle

Inspect disposal and recomputation in Riverpod logs. Use
`@Riverpod(keepAlive: true)` only when state must survive with no listeners. Otherwise keep
auto-disposal and clean up resources with `ref.onDispose`. A short
`ref.keepAlive()` grace window is valid only when traces show rapid
dispose/refetch churn:

```dart
final link = ref.keepAlive();
final timer = Timer(const Duration(seconds: 3), link.close);
ref.onDispose(timer.cancel);
```

Do not add a manual reset or keepAlive as a speculative freeze fix.

### Transition rendering

If the frame timeline pins the transition, replace only the affected route's
page transition with `NoTransitionPage` or a lightweight
`CustomTransitionPage`, preserving its `AppRoute` path and back behavior.

### Navigation guards

Prevent duplicate pushes with an in-flight flag and reset it from the
`Future` returned by `context.push(AppRoute.target)`. Do not infer completion
from a synchronous router-listener snapshot.

### Periodic work

Cancel timers in lifecycle cleanup. If work must pause while the route is
covered, bind it to route visibility or `TickerMode`; `Timer.periodic` does not
pause automatically with Flutter tickers.

## 5. Verify the mechanism

Repeat the original rapid navigation sequence in profile mode, confirm taps are
not buffered, confirm one destination is pushed, and inspect the timeline for
the removed stall. Run focused tests and root `AGENTS.md` verification. Do not
claim an iOS compositor or provider-disposal root cause without matching trace
evidence.
