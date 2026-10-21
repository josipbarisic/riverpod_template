---
paths:
  - "lib/presentation/**/*.dart"
---

# Widget Rules

## Base class

Choose the narrowest base class the widget needs:

| Need | Base class |
|---|---|
| Riverpod only | `ConsumerWidget` |
| Hooks only | `HookWidget` |
| Riverpod and hooks | `HookConsumerWidget` |
| Neither | `StatelessWidget` |
| Owned lifecycle not covered by hooks | `StatefulWidget` |

Do not add hooks or Riverpod access only to justify a broader base class.

## Build order

```dart
class FeatureView extends HookConsumerWidget {
  const FeatureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Hooks
    final scrollController = useScrollController();
    // 2. Providers
    final state = ref.watch(featureControllerProvider);
    // 3. Listeners
    ref.listen(featureControllerProvider, (previous, next) {/* side effects */});
    // 4. Widget tree; complex sections live in their own files
    return Scaffold(body: FeatureContent(controller: scrollController, state: state));
  }
}
```

## One widget class per file

Each widget class lives in its own Dart file. Extract a coherent section when a view approaches
250 lines or its widget tree stops scanning cleanly. A private `State`, `CustomPainter`,
`CustomClipper`, or `RenderObject` owned only by that widget may remain in the same file.

Never use private `Widget _buildX()` helpers or private `_WidgetName` classes. Extract a named
widget instead.

## Layer boundaries

- Views and widgets own composition, local UI state, hooks, provider watches, navigation calls,
  and user-event wiring.
- Controllers own feature behavior and state transitions.
- Repositories and services own external I/O.

Do not make API or Firebase calls directly from a view. Read controller notifiers in callbacks and
watch provider state for rendering.

## Project presentation APIs

Reuse `lib/core/theme/` colors and text styles instead of introducing one-off paint values when an
existing token fits. Use `SnackbarMixin` for application snackbars rather than duplicating
message-display plumbing.

## Keys on dynamic lists

A stateful child (`HookWidget`, `StatefulWidget`, anything holding a notifier) built from a mutable
collection carries a stable key on the widget the parent actually matches, which may be a wrapping
`Padding`. Namespace the key when two id spaces share one list (`ValueKey('order-${o.id}')`,
`ValueKey('draft-${d.id}')`). Unkeyed same-type siblings are matched by slot, so hook state stays
with the slot when an item is removed and lands on whatever takes its place.

A keyed `ListView.builder` over a mutable list also sets `findChildIndexCallback` (key → new index);
without it the builder cannot find a moved child, and a row loses its state when a row above it is
removed. Never gate a state reset behind `context.mounted` of a subtree a key change can tear down;
reset on the notifier you own.

## Clearing a fixed overlay

A trailing gap whose job is to clear a fixed overlay (a bottom bar under `extendBody`, a pinned
footer) derives from that overlay's inset: `SizedBox(height: MediaQuery.paddingOf(context).bottom)`.
A pinned panel's bottom padding floors the system inset at its own gap,
`math.max(MediaQuery.paddingOf(context).bottom, gap)`: Android can report a zero bottom inset, which
puts the last button on the screen edge.

When widget behavior changes, update the relevant test. Root `AGENTS.md` owns which local test
commands to run.
