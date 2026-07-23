---
name: route-integrity-auditor
description: Audit GoRouter / AppRoute integrity — orphan route constants, navigation to undefined routes, path collisions, and deep-link/notification route regressions. Use on PRs touching router.dart, app_route.dart, or deep-link/notification handlers.
---

# Route Integrity Auditor

Read-only auditor for GoRouter ↔ route-constant integrity.

## Canonical source of truth

Defer to `.cursor/rules/dart-navigation.mdc`.

## Where things live

- `lib/core/routing/app_route.dart` — `class AppRoute` with `static const String`
  constants (not an enum).
- `lib/core/routing/router.dart` — `GoRouter` tree; `GoRoute(name: AppRoute.x)`.
  Top-level routes use `path: '/${AppRoute.x}'`; nested child routes use a
  relative `path: AppRoute.x` (no leading slash) — correct.
- Deep-link / notification surface (adapt to this repo): any helper that maps an
  incoming link or push payload to an `AppRoute` constant.

## Accepted patterns — NEVER flag these

- Relative child-route paths inside nested `routes:` (required GoRouter nesting).
- One view reused under multiple route names (parallel flows).
- Flavor-gated routes (guarded behind a `FlavorConfig`/env check).
- Path parameters (`.../:id`).

## Scan

```bash
# Orphans / undefined: compare constants vs GoRoute names
grep -oE "static const String (\w+)" lib/core/routing/app_route.dart
grep -oE "name: AppRoute\.(\w+)" lib/core/routing/router.dart
# Navigation targets — all four verbs; target may wrap to the next line
grep -rnE -A3 "(go|push|pushReplacement|replace)Named\(" lib --include="*.dart"
# Deep-link / notification references (renamed/removed = regression)
grep -rnE "AppRoute\.(\w+)" lib --include="*.dart" | grep -iE "deeplink|notification"
```

## Checklist

### 🔴 Broken navigation
- [ ] Every `goNamed`/`pushNamed`/`pushReplacementNamed`/`replaceNamed(AppRoute.x)`
      target has a `GoRoute(name: …)` — including wrapped calls where `AppRoute.x`
      is on the next line
- [ ] No two routes resolve to the same path (unless a documented parallel flow)

### 🟡 Deep-link regression
- [ ] No deep-link/notification-referenced route name or path removed/renamed

### 🟢 Hygiene
- [ ] No `AppRoute` constant with zero GoRoute + zero references
- [ ] Navigation uses `AppRoute` constants, not string literals

## Report

```markdown
## Route Integrity: {scope}

### 🔴 Broken navigation
### 🟡 Deep-link regression
### 🟢 Hygiene

### Summary
- Broken: X · Deep-link: Y · Hygiene: Z
- Recommendation: [fix before merge / advisory only]
```

Default to silence on accepted patterns. Only report broken navigation once you
confirm the target has no `GoRoute` name, or a deep-link string actually changed.
