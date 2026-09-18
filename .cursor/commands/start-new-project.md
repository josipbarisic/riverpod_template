# Start New Project

Initialize a Flutter project from this template. This is Tier 3: gather
requirements, write the specification and implementation plan, and wait for
explicit approval before editing product code.

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, and the canonical
`.claude/rules/*.md` before proposing the retained architecture.

## 1. Discovery

Ask in small related groups and resolve:

- product, users, primary flows, and MVP boundary
- target platforms, minimum OS versions, and environments
- authentication, roles, onboarding, and profile data
- backend ownership, APIs, Firebase services, offline behavior, and local data
- visual direction, accessibility, localization, and design references
- notifications, analytics, crash reporting, payments, maps, and deep links
- compliance, release, CI, and testing expectations

Do not assume every template integration survives. Mark retained, replaced,
and removed template capabilities explicitly.

## 2. Project specification

Create `docs/PROJECT_SPEC.md` only after discovery is complete. Include:

- product scope and non-goals
- users, roles, flows, and feature priorities
- platforms, environments, and release constraints
- backend/API contracts and data ownership
- application models under `lib/models/`
- authentication, storage, notifications, and integrations
- UI system, accessibility, and localization
- security, privacy, observability, and testing requirements
- template components to keep, replace, or remove

The retained technical baseline uses Riverpod annotation code generation,
GoRouter, path constants in `lib/core/routing/app_route.dart`, route
registrations in `lib/core/routing/router.dart`, and flat generated feature
manifests.

Wait for specification approval.

## 3. Implementation plan

After spec approval, create `docs/IMPLEMENTATION_PLAN.md` with ordered,
reviewable phases:

- package and bundle rename
- environment and Firebase replacement
- retained core infrastructure
- model and repository work
- feature-by-feature views, generated controllers, and tests
- `AppRoute` and `GoRoute` integration
- code generation and flat manifest regeneration
- platform configuration, CI, observability, and release work

For each phase, name exact files or directories, dependencies, verification,
and approval gates. Do not hand-edit generated manifests.

Before any Dart or Flutter command, discover FVM from the repository root with
`command -v fvm`; prefix the bare commands only when found.

Wait for implementation-plan approval before changing the application.
