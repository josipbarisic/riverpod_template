---
description: Analyse a feature with manifest-based discovery and structured report
---

## Analyse Feature

Run a read-only feature analysis grounded in current source.

## 1. Resolve the feature

Map the requested feature to `lib/presentation/<feature>/` and the flat
`lib/manifests/<feature>.manifest.generated.json`. Ask which feature only when
the request does not identify one.

## 2. Read the contract and source

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, and matching
`.claude/rules/*.md`. Read the manifest as an index, then inspect:

- views, widgets, controllers, and states
- generated provider source declarations, excluding generated Dart output
- repositories and application models under `lib/models/`
- `lib/core/routing/app_route.dart`, `router.dart`, and navigation call sites
- relevant services, endpoint definitions, and tests

Do not infer freshness from timestamps alone. If structural source changed
without a manifest update, report a stale candidate and the bare refresh
command from root `AGENTS.md`.

## 3. Report

Cover only applicable sections:

1. Purpose and user flow
2. Layer ownership and data flow
3. Riverpod state, dependencies, and lifecycle
4. Repository, model, endpoint, and external-service behavior
5. `AppRoute` paths, `GoRoute` registrations, and entry points
6. Rendered states and key widgets
7. Existing tests and uncovered behavior
8. Confirmed strengths, gaps, and risks

Cite source paths and line numbers for findings. Distinguish current behavior
from recommendations. Do not edit source, manifests, or documentation unless
the user separately requests implementation.
