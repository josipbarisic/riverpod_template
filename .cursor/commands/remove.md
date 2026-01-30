---
description: Logically remove a feature, widget, or file and all references with impact analysis and safety warnings
---

## Remove Feature / Widget / File

**Safely remove** a feature, widget, or file and **all references** across the codebase. Use discovery, impact analysis, and explicit warnings when the removal affects other app components.

**Reference:** `lib/AGENTS.md`, `lib/manifests/`, `lib/routing/router.dart` (RoutePath is defined there; there is no separate app_route file).

---

### Step 1: Identify the Target (MANDATORY)

**Ask the user if not clear:**

- **Feature:** e.g. `login`, `sign_up`, `home` → entire feature directory and its route(s), providers, repository.
- **Widget / single file:** e.g. `lib/presentation/login/login_view.dart` or "LoginView" → that file plus generated files (e.g. `.g.dart` only if it's a provider).
- **File path:** Exact path under `lib/` (e.g. `lib/data/repositories/auth_repository/auth_repository.dart`).

**Resolve to a concrete scope:**

- **Scope A – Single file (or file + generated):** One primary file; list any generated files that must be deleted with it (e.g. `*_controller.g.dart`, `*.freezed.dart` for a model).
- **Scope B – Feature:** Entire feature directory under `lib/presentation/{feature}/`, plus:
  - Route(s) in `lib/routing/router.dart` (RoutePath constant and GoRoute)
  - Repository under `lib/data/repositories/{feature}_repository/` if the feature manifest lists it
  - Manifest at `lib/manifests/{feature}.manifest.generated.json`
  - Feature README at `lib/presentation/{feature}/README.md` (if exists)
  - Entry points: bottom navigation, tabs, or navigation calls from other features

**Output:** "**TARGET:** [Scope A: path(s) | Scope B: feature name and paths]. **PRIMARY FILES TO REMOVE:** [list]."

---

### Step 2: Mandatory Reads (ZERO-DRIFT)

Before any removal plan:

1. **Read `lib/AGENTS.md`** – manifest layout, routing, layers, "When the manifest looks wrong".
2. **Resolve manifest(s):**
   - **Scope A (single file):** Determine which feature/folder the file belongs to; read that feature's manifest: `lib/manifests/{feature}.manifest.generated.json`.
   - **Scope B (feature):** Read `lib/manifests/{feature}.manifest.generated.json`.
3. **Read routing:** `lib/routing/router.dart` (RoutePath class and GoRoute definitions).
4. **Discover all references** (use grep/search; do not guess):
   - **Imports:** Any file that imports the target file or a removed class.
   - **Route usage:** `RoutePath.<routeName>`, `context.go(RoutePath.xxx)`, `context.push(RoutePath.xxx)`. Search in `lib/` (and optionally `test/`).
   - **Provider usage:** References to providers listed in the manifest outside the removed set.
   - **Class/widget name:** References to the removed class or widget name in `lib/` and `test/`.
   - **Entry points:** Bottom navigation, home, or other views that navigate to this feature.

**List:**

- **FILES TO DELETE:** [paths]
- **FILES THAT REFERENCE THE TARGET:** [path → what to remove: import, route def, route constant, navigation call, provider usage, widget usage]

---

### Step 3: Impact Analysis (CRITICAL)

Determine whether the removal is **isolated** or **impacts other app components**. Use this to decide whether to show an **IMPORTANT WARNING** and block until the user explicitly approves.

**Impact checks:**

1. **Is the target a route/screen?** (View is registered in `router.dart` with RoutePath and GoRoute.) → **WARNING:** Yes.
2. **Is the target used by another feature?** (References in a different feature folder or lib/core, lib/presentation/widgets.) → **WARNING:** Yes.
3. **Is the target a repository or provider used outside the removed set?** → **WARNING:** Yes.
4. **Is the target a shared widget used in multiple features?** → **WARNING:** Yes.
5. **Is the target only used inside the same feature (or only by the files being deleted)?** → **WARNING:** No (still list entry-point changes).

**Output:** "**IMPACT:** [Isolated | Impacts: list]. **WARNING REQUIRED:** [Yes | No]."

---

### Step 4: IMPORTANT WARNING (When Required)

If **WARNING REQUIRED: Yes**, output a clear warning **before** proposing the removal plan:

- List what will break (route/screen, feature, file path).
- State: "You must either (1) update or remove the listed references in the same change, or (2) accept that those components will break until fixed."
- **Stop.** Do not delete or edit until the user gives **explicit confirmation** (e.g. "yes", "proceed", "remove it and fix references").

---

### Step 5: Removal Plan

**When WARNING REQUIRED: No**, or **after the user has confirmed** when WARNING was required:

1. **References to remove first:** Entry points → route definition and RoutePath constant in `lib/routing/router.dart` → imports and usages in other files → provider registration.
2. **Files to delete:** Primary files; generated files (`.g.dart`, `.freezed.dart`) only for removed sources; feature README (Scope B). Prefer **not** deleting the manifest file; regenerate manifests at the end.
3. **After removal:** Run `dart run scripts/generate_feature_manifests.dart`, then `flutter analyze` (or `dart analyze`). If needed, run `dart run build_runner build -d`.

For **Scope B** or when **WARNING was shown**, ask: "Proceed with this removal plan? (yes/no)" and wait for confirmation before executing.

---

### Step 6: Execute Removal

1. Apply reference removals in order: entry points → route definition and RoutePath constant → imports and usages → provider registration.
2. Delete primary and generated files (no dangling imports).
3. Regenerate manifests: `dart run scripts/generate_feature_manifests.dart`.
4. Run `flutter analyze`; fix any remaining errors.
5. State result: "Removed: [list]. Updated: [list]. Regenerated manifests. Analysis: [pass/fail]."

---

### Rules

- **Never delete files** before removing all references to them.
- **Never remove** a RoutePath constant or GoRoute without removing/updating every place that navigates to that route.
- **Never leave** broken imports or undefined symbols.
- **Always run** the manifest generator after structural removal; do not manually edit `.manifest.generated.json`.
- **When in doubt** about impact, treat as impactful and show the **IMPORTANT WARNING**.
- **Generated files:** Only delete `.g.dart` / `.freezed.dart` when the corresponding source file is being deleted.
