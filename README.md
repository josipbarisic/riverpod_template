# riverpod_template

A Flutter application template with Riverpod code generation, Freezed models, GoRouter,
Firebase integrations, dev/prod flavors, and generated feature manifests.

## Run the template

```bash
flutter pub get
cp .env.example .env
flutter run --flavor dev -t lib/main_dev.dart
```

The production entry point is `lib/main_prod.dart`:

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

Commands are documented in bare Flutter/Dart form. `AGENTS.md` defines the FVM discovery policy
for automated work without making FVM a template dependency.

## Architecture

```text
lib/
├── core/          # Routing, services, theme, configuration, utilities
├── data/          # Firebase integration and repositories
├── models/        # Freezed application models
├── presentation/  # Feature-grouped views, controllers, states, widgets
└── manifests/     # Generated feature context
```

Read `ARCHITECTURE.md` for layer responsibilities and `lib/AGENTS.md` for the live feature and
manifest workflow.

Riverpod providers use annotation-based generation only. Project imports use direct
`package:riverpod_template/...` paths.

## Code generation

After changing Riverpod, Freezed, or JSON-serializable annotations:

```bash
dart run build_runner build -d
```

Never hand-edit `*.g.dart` or `*.freezed.dart`.

## Feature manifests

`scripts/generate_feature_manifests.dart` scans `lib/presentation/`,
`lib/core/routing/app_route.dart`, `lib/core/routing/router.dart`, repositories, providers, and
tests. It writes `lib/manifests/<feature>.manifest.generated.json`.

Regenerate after structural feature changes:

```bash
dart run scripts/generate_feature_manifests.dart
```

Generated manifests are context, not source. Do not edit them by hand.

## Analyze and test

```bash
flutter analyze
flutter test
flutter test test/presentation/login/
flutter test --coverage
```

The current suite has tests under `test/domain/`, `test/presentation/`, `test/repositories/`,
`test/services/`, and `test/utils/`, plus shared helpers and test data. The pull-request workflow
runs the full unit/widget suite for application, test, and platform changes.

## Agent instruction model

- `AGENTS.md` is the primary instruction source for every agent.
- `CLAUDE.md` imports `AGENTS.md` and contains only Claude-specific integration notes.
- `.claude/rules/*.md` is the canonical home of path-scoped rules.
- `.claude/skills/*/SKILL.md` contains reusable workflow implementations.
- `.claude/agents/*.md` contains read-only advisory reviewers.
- `lib/AGENTS.md` covers feature manifests, layer placement, and test discovery.
- `docs/LEARNING_LOG.md` stores traps: failure mechanisms nothing else guards.

## Starting a project from the template

In Claude Code, `/start-new-project` runs the discovery, specification, and plan workflow below with
approval gates. By hand:

1. Rename `riverpod_template` in `pubspec.yaml`, Dart package imports, bundle/application
   identifiers, and instruction examples.
2. Replace template Firebase and environment configuration for the new application.
3. Run code generation.
4. Regenerate feature manifests.
5. Run `flutter analyze` and `flutter test`.

This repository is a starting point. Keep the layers and generated workflows only where they fit
the resulting application.
