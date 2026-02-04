# Cursor Commands (AI-First Template)

Slash commands for standardized AI workflows. Type `/` in Cursor Chat to see them.

## Core Commands

- **`/add-feature`** - Add a new feature/screen (complexity Tier 1/2/3; Tier 3 requires approval)
- **`/refine-feature`** - Iteratively refine an existing feature (violations, integrations, code quality)
- **`/fix-bug`** - Fix bugs with proper context and manifest usage
- **`/test`** - Create tests for features, files, methods, or widgets (unit, widget, or integration)
- **`/review`** - Pre-commit review (security, imports, NEVER rules, file size, **run tests**)
- **`/commit`** - Create secure, atomic commits (security scan; untracked files confirmed before adding)
- **`/regenerate-manifests`** - Regenerate feature manifests after structural changes
- **`/analyse`** - Analyse a feature (manifest-based discovery, structured report)
- **`/remove`** - Logically remove a feature, widget, or file and all references (impact analysis; IMPORTANT WARNING when removal affects other app parts)

## Workflow

- **`/branch`** - Create feature branch
- **`/pr`** - Create PR description

## Skills

Agent skills (optional, for deeper workflows) live in `.cursor/skills/`:

- **flutter-code-review** – Review code for architecture violations and template patterns
- **flutter-ui-refinement** – Refine UI with reference patterns and design options
- **git-commit** – Well-formatted commits with security scan and prefix/conventional format
- **feature-planning** – Plan new features with widget decomposition and integration analysis

## Patterns

- **Mandatory reads:** ARCHITECTURE.md (or AGENTS.md), feature manifest; check staleness.
- **State what you read** before implementing.
- **Complexity:** Ask Tier 1/2/3 at start; Tier 3 = wait for approval.
- **Routes:** Use `RoutePath.xxx` (defined in `lib/routing/router.dart`).
- **Manifests:** `lib/manifests/{feature}.manifest.generated.json`.

## Regenerate Manifests

After adding views, controllers, routes, or repositories:

```bash
dart run scripts/generate_feature_manifests.dart
```

See `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md` for discovery depth by tier.
