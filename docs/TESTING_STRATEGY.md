# Testing Strategy

Root `AGENTS.md` owns when tests run and the FVM discovery required before
Flutter commands. `lib/AGENTS.md` owns feature-test discovery through flat
feature manifests. This file records only the stable testing approach.

## Test the public behavior

Pin controller state transitions, repository and service outcomes, model
serialization, widget rendering and interaction, and complete flows where
cross-feature confidence is required. Do not assert generated Riverpod or
Freezed implementation details.

Use `ProviderContainer` overrides for generated providers. Mock repositories,
services, platform APIs, and external SDKs rather than controllers. Reuse the
nearest existing fixture and matcher style.

## Live layout

- controllers and feature behavior: `test/presentation/<feature>/`
- repositories: `test/repositories/`
- services: `test/services/`
- application models from `lib/models/`: `test/domain/`
- utilities: `test/utils/`
- fixtures and helpers: `test/test_data/`, `test/helpers/`
- broad widget smoke coverage: `test/widget_test.dart`

Confirm paths in the live `test/` tree. For a feature, use
`lib/manifests/<feature>.manifest.generated.json` as a discovery index, then
verify `testing.testFiles` and `testing.runCommand` before relying on them.

## Widget test techniques

### Prove the test can fail

A green test proves nothing until it has been red. Before trusting a regression or guard test:

- Set aside only the fixed production file (`git stash push -- <path>`), rerun the single test with
  `--plain-name`, watch it fail, then `git stash pop`. When the fix is already committed, run the
  test in a throwaway `git worktree add --detach <dir> <base>` instead.
- Assert the precondition, not only the outcome: the button is disabled before the enabling action,
  and tapping it then did not navigate. `expect(tester.takeException(), isNull)` passes trivially in
  a test that never reproduces the fault.
- `tester.pump()` runs a frame only when one is scheduled. A test that needs a frame callback calls
  `tester.binding.scheduleFrame()` first and asserts the callback ran.
- `tester.drag` on a finder whose centre is off-screen logs a hit-test warning and does nothing.
  Drag a visible child and assert the content moved (`getTopLeft(...).dy`) before anything that
  depends on the scroll.
- A busy guard ("ignore taps while pending") needs a fake that stays busy: hand each call its own
  `Completer` and assert how many were opened. An already-completed `Future` resolves before the
  second tap lands, so the test passes with or without the guard.
- To simulate a `State` disposed mid-operation, `pumpWidget` a new tree with a new key on the root
  `MaterialApp`.

### Layout and geometry

- `takeException()` misses clipping: a fixed header can clip its text with no overflow error.
  Compare each paragraph's rendered height against its intrinsic height at large text scales.
- Settle before `getRect`: it includes entrance transforms still running. Measure tap-target
  minima with `getSize`; subtracting global rects returns 43.99999999999997 for a 44-point target.
- Geometry that depends on text wrapping loads the production fonts; the test font wraps
  differently.
- A fixture for safe-area-dependent UI sets `MediaQueryData.viewPadding`, not only `padding`.

### Scrolling and controlled widgets

- A controlled widget's test feeds the callback value back (`StatefulBuilder`) and rebuilds, then
  holds a gesture across a rebuild and asserts the offset stays continuous.
- `ensureVisible` scrolls every ancestor, nested horizontal lists included. To reach a
  below-the-fold slot without scrolling an inner list, jump the outer `Scrollable` instead.

### Riverpod, mocks and navigation

- `ref.listen` fires on changes only: emit the `AsyncError` from a fake notifier after the first
  pump, never from `build()`. Match the fake's `build()` return type exactly.
- A generated provider keeps a test offline only when overridden. An unoverridden repository hits
  real Dio and stalls `pumpAndSettle`.
- Overlapping mocktail `any(named:)` stubs on one method: the last match wins. Serve sequential
  calls from one `thenAnswer` that dispatches on the argument.
- `tester.binding.handlePopRoute()` is system back: it reaches `PopScope.onPopInvokedWithResult`.
- Test redirect logic on a mirrored `GoRouter` with stub views; the real router pulls in every
  feature tree.

### Proving a refactor is UI-neutral

Paste the previous implementation into the test as a private class and render it beside the new
one: compare `getRect` and raw pixels (`RepaintBoundary` → `toImage()` → `toByteData(rawRgba)`
inside `tester.runAsync`). Cover the configurations that can diverge: shrink-wrap, overflow
painting, scrolled to `maxScrollExtent`, keyboard insets.

## Execution

Run the narrowest relevant path while iterating:

```bash
flutter test test/presentation/login/
```

Run the full suite only when root `AGENTS.md` requires it. CI behavior is owned
by the live workflow under `.github/workflows/`, not this document.
