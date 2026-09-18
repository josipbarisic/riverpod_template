---
description: Iteratively refine an existing feature - fix violations, add integrations, improve code quality
---

## Refine Existing Feature

Use root `AGENTS.md` for the supplied or requested complexity tier. Tier 3
requires a grounded plan and explicit approval before editing.

## 1. Resolve the refinement

Identify the exact behavior, UI, integration, architecture, or performance
problem and its non-goals. Read:

- `ARCHITECTURE.md` and `lib/AGENTS.md`
- matching `.claude/rules/*.md`
- the regenerated flat feature manifest
- target source, nearest reference implementation, and relevant tests

Before Dart or Flutter commands, use root FVM discovery. Treat the manifest as
an index and verify every symbol in live source.

## 2. Find the mechanism

For correctness work, reproduce or trace the behavior before editing. For UI
work, inspect the target and reference widget plus `lib/core/theme/`. For
integration work, trace controller, repository, model under `lib/models/`,
`AppRoute` path, `GoRoute`, and call sites.

Report only confirmed violations of canonical rules. JSON boundary `dynamic`
and raw layout values are not automatic defects.

## 3. Plan and implement

Tier 2 gets a brief file-level plan. Tier 3 gets the full behavior, data flow,
files, risks, tests, generated outputs, and approval checkpoint.

Implement the smallest coherent change. Keep Riverpod in annotation code
generation mode, external I/O outside views, one widget class per file, direct
package imports, and generated files unedited.

## 4. Verify

Run only applicable bare commands after FVM discovery:

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
flutter analyze
flutter test <focused-test-path>
```

Follow root `AGENTS.md` for broader tests. Report the finding, mechanism,
changed paths, generated outputs, and exact verification results.
