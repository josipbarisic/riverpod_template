# Riverpod Template Architecture

This template uses a layered Flutter structure with feature-grouped presentation code,
annotation-generated Riverpod providers, Freezed models, GoRouter, and Firebase-backed services.

## Structure

```text
lib/
├── core/
│   ├── config/
│   ├── constants/
│   ├── enums/
│   ├── extensions/
│   ├── mixins/
│   ├── routing/
│   ├── services/
│   ├── theme/
│   └── utils/
├── data/
│   ├── firebase/
│   └── repositories/
├── models/
├── presentation/
│   ├── bottom_navigation/
│   ├── home/
│   ├── login/
│   ├── onboarding/
│   ├── profile/
│   ├── sign_up/
│   ├── splash/
│   └── widgets/
└── manifests/
```

Check the live directories and feature manifests for the current file list. This document owns
stable placement, not an exhaustive inventory.

## Layers

### Core — `lib/core/`

Shared infrastructure and cross-feature concerns:

- app configuration and constants
- routing in `lib/core/routing/`
- services for network, language, local notifications, and shared preferences
- theme colors and text styles
- reusable extensions, mixins, formatters, and helpers

Core code stays feature-agnostic. Feature-specific behavior belongs with the feature.

### Data — `lib/data/`

External integration and data access:

- Firebase access in `lib/data/firebase/`
- repository contracts, implementations, and generated providers in
  `lib/data/repositories/<name>_repository/`

Views call controllers; controllers read repositories through Riverpod; repositories and services
perform external I/O.

### Models — `lib/models/`

Application entities are grouped by concept. The current models use Freezed and JSON code
generation. Keep models independent of widget concerns.

### Presentation — `lib/presentation/`

UI is grouped by feature:

- `*_view.dart` composes screens.
- `*_controller.dart` owns feature state and behavior.
- `*_state.dart` holds explicit state where `AsyncValue<T>` alone is insufficient.
- Feature-local widgets belong under that feature; widgets shared by multiple features currently
  live in `lib/presentation/widgets/`.

Views may own local UI state, hooks, navigation, and event wiring. They do not perform repository,
network, or Firebase work directly.

## Riverpod

Providers and notifiers use `riverpod_annotation` code generation only:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class ExampleController extends _$ExampleController {
  @override
  bool build() => false;
}
```

Use `@riverpod` for default auto-disposal and `@Riverpod(keepAlive: true)` only for intentional
no-listener persistence. Function providers receive Riverpod 3's `Ref` type. Controllers obtain
dependencies through generated providers so tests can override them with `ProviderContainer`.

Small explicit states may use Equatable; generated immutable models and larger state shapes may use
Freezed. `.claude/rules/dart-state.md` owns ref access and lifecycle details.

## Navigation

- Path constants: `lib/core/routing/app_route.dart`
- GoRouter configuration: `lib/core/routing/router.dart`
- Transition widgets: `lib/core/routing/page_transitions.dart`

The current routes are path-based and have no GoRouter `name` values. Navigation should use
`context.go(AppRoute.x)` or `context.push(AppRoute.x)`; named navigation is invalid until the
corresponding `GoRoute` has a `name`. Adding a route requires changes to both `app_route.dart` and
`router.dart`, followed by manifest regeneration.

## Imports and widgets

Project imports use direct `package:riverpod_template/...` paths. Relative imports and barrel
exports are not part of the architecture.

Widget base classes, extraction rules, naming, and expression-body conventions are owned by
`.claude/rules/dart-widgets.md` and `.claude/rules/dart-conventions.md`.

## Generated artifacts

Riverpod, Freezed, and JSON serialization emit `*.g.dart` and `*.freezed.dart`. Feature discovery
emits `lib/manifests/*.manifest.generated.json`. Generated files are outputs, never hand-edited.
Root `AGENTS.md` owns generation commands and timing.

## Tests

The live suite contains:

```text
test/
├── domain/
├── helpers/
├── presentation/
├── repositories/
├── services/
├── test_data/
├── utils/
├── network_response_test.dart
└── widget_test.dart
```

Controller tests use `ProviderContainer` overrides. Repository and service tests isolate external
dependencies with test doubles. Test behavior and public outcomes rather than generated
implementation details. Root `AGENTS.md` owns local and pre-commit test commands.

## Ownership

- `AGENTS.md`: workflow, verification, generation, and Git safety
- `lib/AGENTS.md`: feature manifests and feature-test discovery
- `.claude/rules/*.md`: path-scoped coding constraints
- `.claude/skills/*/SKILL.md`: reusable workflow implementations
- `.claude/agents/*.md`: read-only advisory reviewers
- `.cursor/rules/*.mdc`: Cursor attachment pointers only
