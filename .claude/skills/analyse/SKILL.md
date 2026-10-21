---
name: analyse
description: Analyse one feature with manifest-based discovery and produce a structured, read-only report of its views, controllers, state, repositories, services, routes, and tests. Use when the user types /analyse or asks for a report on a feature before changing it.
disable-model-invocation: true
---

# Analyse Feature

Run a read-only analysis of one feature, grounded in current source. Root
`AGENTS.md` owns commands and FVM discovery; `lib/AGENTS.md` owns the manifest
workflow.

## 1. Resolve the feature

Map the request to `lib/presentation/<feature>/` and the flat
`lib/manifests/<feature>.manifest.generated.json`. When the request names no
feature, list the directories under `lib/presentation/` and ask which one.

## 2. Read the contract and the index

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, and the matching
`.claude/rules/*.md`. Then check manifest freshness:

```bash
node scripts/ai/check_manifest_freshness.mjs
```

If the feature is reported, say the manifest may be stale and give the refresh
command from root `AGENTS.md`. Read the manifest as an index and state what it
lists: views, controllers, widgets, providers and state classes, routes,
repositories, core services, third-party dependencies, and testing metadata.
When the manifest looks wrong, the generator is the bug: say so instead of
reasoning around it.

## 3. Read the source

Verify every manifest claim in live source:

- views, widgets, controllers, and states
- provider declarations, not the generated `*.g.dart` output
- repositories and models under `lib/models/`
- the services the feature depends on
- `lib/core/routing/app_route.dart`, `lib/core/routing/router.dart`, and the
  feature's navigation call sites
- existing tests under `test/presentation/<feature>/` and the data they use

Read only as deep as the report needs.

## 4. Report

Cover only the sections that apply:

1. **Purpose and flow**: what the feature does and its main user flows.
2. **Layers and data flow**: view → controller → repository or service, with
   the providers and state types involved.
3. **State and lifecycle**: providers, `keepAlive` choices, disposal, streams.
4. **Data**: repositories, Firebase access, endpoints, and models.
5. **Routes**: `AppRoute` paths, `GoRoute` registrations, and entry points.
6. **Rendered states**: loading, empty, error, and data; key widgets.
7. **Tests**: existing coverage and untested behavior.
8. **Strengths, gaps, and risks**: confirmed findings only, each with
   `path:line`.
9. **Recommendations**: concrete next steps, kept separate from current
   behavior.

Offer one follow-up (plan a change, write tests, fix a finding) and stop.

## Rules

- Read-only: do not edit source, manifests, or documentation unless the user
  separately asks for implementation.
- Keep the scope to the chosen feature and its direct dependencies.
- Never recommend relative imports, route string literals, or hand-edited
  manifests.
