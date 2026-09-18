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

Stateful or hook-bearing children rendered from a mutable collection need stable keys on the
widgets the parent matches by index.

When widget behavior changes, update the relevant test. Root `AGENTS.md` owns which local test
commands to run.
