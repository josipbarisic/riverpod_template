---
description: Fix any issue — GitHub issue, bug report, or other issues
---

## Fix Issue

Diagnose and fix a scoped GitHub issue, bug report, or observed failure.

## 1. Resolve the report and tier

If the input is an issue number or URL, read it with the repository's GitHub
integration. Otherwise capture the failing behavior, expected behavior,
reproduction, environment, and available logs. Use the tier supplied by the
user; ask once when absent as required by root `AGENTS.md`.

## 2. Ground the diagnosis

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, matching
`.claude/rules/*.md`, affected source, and relevant tests. For feature work:

1. discover FVM from the repository root as defined by `AGENTS.md`
2. run the bare manifest generator
3. read `lib/manifests/<feature>.manifest.generated.json`
4. verify every manifest claim against live source

Trace the actual mechanism through views, generated Riverpod declarations,
controllers, repositories, services, models under `lib/models/`, and both
`app_route.dart` and `router.dart` when navigation is involved.

For iOS transition freezes, use
`.claude/skills/flutter-ios-transition-freeze/SKILL.md`.

## 3. Plan by complexity

- Tier 1: implement once the cause and minimal fix are clear.
- Tier 2: state a brief file-level plan, then implement.
- Tier 3: present the root-cause evidence, full plan, risks, tests, and
  generated outputs; wait for explicit approval.

## 4. Implement the causal fix

Change only the code responsible for the observed behavior. Use Riverpod
annotation code generation only, keep I/O outside views, preserve path-based
`AppRoute` navigation, and never edit generated Dart or manifest files.

Add or update a regression test when behavior changes. Use the closest existing
test pattern rather than a generic template.

## 5. Generate and verify

After root FVM discovery, run applicable bare commands:

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
flutter analyze
flutter test <focused-test-path>
```

Follow root `AGENTS.md` for broader tests. Report the finding first, the one
mechanism that caused it, changed and generated paths, and exact verification
results. Do not create a commit or pull request unless separately requested.
