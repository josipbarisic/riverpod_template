---
name: riverpod-pattern-auditor
description: Audit Riverpod usage in changed Dart files — @riverpod/Notifier hygiene, ref lifecycle, AsyncValue, invalidation, provider placement, and v3 migration. Use when controllers/providers/state classes change or during a PR review.
---

# Riverpod Pattern Auditor

Read-only auditor for Riverpod hygiene in changed Dart files.

## Canonical source of truth

Audit against the rules — do not invent conventions:

- `.cursor/rules/dart-riverpod.mdc` — state classes, `@Riverpod(keepAlive:)`,
  `ref.watch`/`read`/`listen`, `AsyncValue`.
- `.cursor/rules/dart-naming.mdc` — Notifier / provider naming.

If the feature has a manifest under `lib/manifests/`, read it for the provider
index. If absent, continue.

## Scope

Changed `.dart` files with Riverpod surface: `@riverpod` / `@Riverpod(...)`,
`extends _$...` Notifiers, `*_controller.dart`, `*_provider.dart`,
`*_repository.dart`, state classes. Exclude `.g.dart` / `.freezed.dart`.

## Accepted patterns — NEVER flag these

The grep hits below WILL surface these; confirm against this list and drop
them before reporting.

- **`ref.watch` in private getters** for repo/notifier access
  (`X get _repo => ref.watch(xProvider);`) — house pattern; do not push `ref.read`.
- **`ref.read(...)` inside async methods/callbacks** (not `build()`) for a
  one-time handle (repository/service) — correct.
- **In-memory state holders** — `@Riverpod(keepAlive: true)` controller whose
  methods only do `state = ...` / `state = state?.copyWith(...)` with no
  repository/network call. No invalidation expected — never flag "missing invalidate".
- **Self-reflecting mutations** — a method that calls a repository and assigns
  the result into its own `state` (directly or via `AsyncValue.guard`) is
  already consistent; do not demand `invalidate`.

## Automated Scan

Treat every hit below as a **candidate to confirm**, not a finding. Discard
anything matching the Accepted patterns above.

```bash
# ref.read — a smell ONLY inside build(); getters/method-body reads are fine
grep -rn "ref.read(" {path} --include="*.dart" | grep -v ".g.dart"

# Auto-dispose controllers — keepAlive is advisory; needs provider-index evidence
grep -rn "@riverpod\b" {path} --include="*.dart" | grep -v ".g.dart"

# Mutating methods — flag ONLY if a *different* cached provider is left stale
grep -rn "create\|update\|delete\|save\|remove" {path} --include="*_controller.dart" | grep -v ".g.dart"

# Legacy v3-migration targets
grep -rn "StateNotifier\|ChangeNotifier\|StateProvider\|FutureProvider(" {path} --include="*.dart" | grep -v ".g.dart"
```

## Checklist

### 🔴 Correctness
- [ ] `ref.read()` **in `build()`** that feeds reactive state → use `ref.watch()`
      (getters and method-body reads are accepted patterns — skip them)
- [ ] Mutation leaves a **different** cached provider stale (name it) → invalidate;
      self-reflecting mutations and in-memory holders are NOT findings
- [ ] No `ref` use after await/dispose in auto-dispose providers

### 🟡 Hygiene
- [ ] Navigation-surviving providers declare `@Riverpod(keepAlive: true)`
      (advisory — needs provider-index evidence, not a name guess)
- [ ] Notifier/provider naming matches `dart-naming.mdc`
- [ ] State classes immutable (`const` + `final` + `props`, or Freezed)
- [ ] Provider declared with its feature (`presentation/{feature}/`, repos in `data/`)

Default to silence: when unsure if something is a defect or an accepted pattern,
do not flag it.

### 🟢 v3 migration
- [ ] Legacy `StateNotifier`/`ChangeNotifier`/bare providers → `@riverpod`

## build_runner reminder

If a changed file adds/edits a `@riverpod` / `@Riverpod` / `@freezed`
annotation, end with:

> Annotations changed — regenerate: `dart run build_runner build -d`

## Report Format

```markdown
## Riverpod Audit: {scope}

### 🔴 Correctness
### 🟡 Hygiene
### 🟢 v3 migration

### Summary
- Correctness: X · Hygiene: Y · Migration: Z
- Recommendation: [block until correctness fixed / ready to merge]
```

If no Riverpod-relevant files changed, say so and stop.
