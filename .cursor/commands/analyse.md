---
description: Analyse a feature with manifest-based discovery and structured report
---

## Analyse Feature

Run a **structured analysis** of a feature: purpose, architecture, controllers, API, UI/UX,
strengths, gaps, and recommendations. Use this to onboard, refactor, or document a feature.

**Reference:** `lib/AGENTS.md`, `lib/manifests/{feature}.manifest.generated.json`

---

### Step 1: Identify the Feature

**If the user did not specify a feature:**

- Ask: *"Which feature should I analyse? (e.g. splash, login, sign_up, onboarding, bottom_navigation, home, profile)"*
- Map the answer to the manifest path: `lib/manifests/{feature}.manifest.generated.json`
- See AGENTS.md for manifest locations.

**If the user specified a feature:** resolve it to the correct manifest path and feature directory in `lib/presentation/`.

---

### Step 2: Mandatory Reads (ZERO-DRIFT)

1. **Read `lib/AGENTS.md`** – project patterns, manifest structure, routing, layers.
2. **Read the feature manifest** – `lib/manifests/{feature}.manifest.generated.json`.
3. **Check manifest staleness** – If any file listed in the manifest (views, controllers, widgets, repositories) is newer than `generatedAt`, state that the manifest may be stale and recommend:
   ```bash
   dart run scripts/generate_feature_manifests.dart
   ```
4. **State what you read:**
   - Which files exist in the feature (from manifest `views`, `controllers`, `widgets`, `repositories`).
   - Which controllers/providers and routes are available.
   - Which API endpoints are used (from manifest `apiEndpoints`).
   - Which services are used (from `coreServices` and `thirdPartyDependencies`).

---

### Step 3: Explore the Feature

Read (or skim) the main implementation files to ground the analysis:

- **Views** – at least the main view(s) (e.g. `*_view.dart`).
- **Controllers** – state shape, main methods (from manifest `controllerMethods`).
- **Repository** – interface and key methods (if the feature has a repository in the manifest).
- **Routing** – how the feature is reached (parent route, child routes) and how it navigates (e.g. `AppRoute.xxx`).
- **Feature README** – if present: `lib/presentation/{feature}/README.md`.

Use the manifest to decide what to read; avoid reading every widget file unless needed for depth.

---

### Step 4: Produce the Structured Analysis

Output a clear, markdown-structured report with the following sections. Omit a section only if it truly does not apply (e.g. no API for a pure UI feature).

1. **Purpose & flow**  
   What the feature does and the main user flows (e.g. list → add/edit → delete).

2. **Architecture**
   - Layers: presentation (views, controllers, widgets), data (repository), models.
   - State: main providers, state types (e.g. `AsyncValue<List<T>>`).
   - Routing: how the feature is registered (parent/child), route names used.
   - Services: core services and third-party dependencies used (from `coreServices`, `thirdPartyDependencies`).

3. **Controllers & API**
   - Controllers: build state, main methods (names and short description).
   - Repository: main methods and whether they map to real or mock API.
   - API endpoints: list from manifest (method, path, used in); note any mismatches or TODOs.

4. **UI & UX**
   - Main screens and states (loading, empty, error, data).
   - Notable patterns: optimistic updates, pull-to-refresh, navigation patterns.
   - Key widgets (from manifest) if relevant.

5. **Strengths**
   - What aligns with project rules: clean separation, Riverpod/Freezed, no private widget methods, absolute imports, AppRoute usage, etc.
   - Any particularly good patterns (e.g. optimistic updates, keepAlive usage).

6. **Gaps & risks**
   - Manifest inaccuracies (wrong view name, wrong endpoint/method).
   - Missing docs (e.g. no feature README).
   - Inconsistencies (e.g. snackbar vs ScaffoldMessenger).
   - Backend still mocked, TODOs, or unclear error handling.
   - Missing tests or integration points.

7. **Recommendations**
   - Concrete next steps: fix manifest/generator, add README, unify snackbars, add tests, replace mocks when BE is ready, etc.
   - Optionally: "I can next: (a) fix X, (b) add Y, (c) refactor Z."

---

### Step 5: Optional Follow-Up

If the user asked to "analyse and then fix" or "analyse and add README", proceed with the requested actions after the analysis, using the same manifest and files as context.

---

### Rules

- **Imports:** Do not suggest relative imports; use absolute package imports only (`package:riverpod_template/...`).
- **Routes:** Reference `AppRoute` constants; do not use string literals for route names.
- **Manifests:** Do not edit `.manifest.generated.json` by hand; recommend regenerating or fixing the generator when the manifest is wrong.
- **Scope:** Limit the analysis to the chosen feature and its direct dependencies; do not analyse the whole app unless asked.

---

**Last Updated:** Manifest structure v2 (coreServices, thirdPartyDependencies)
