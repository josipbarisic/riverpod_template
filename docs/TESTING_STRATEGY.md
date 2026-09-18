# Testing Strategy

Root `AGENTS.md` owns when tests run and the FVM discovery required before
Flutter commands. `lib/AGENTS.md` owns feature-test discovery through flat
feature manifests. This file records only the stable testing approach.

## Test the public behavior

Pin controller state transitions, repository and service outcomes, model
serialization, widget rendering and interaction, and complete flows where
cross-feature confidence is required. Do not assert generated Riverpod or
Freezed implementation details.

Use `ProviderContainer` overrides for generated providers. Mock repositories,
services, platform APIs, and external SDKs rather than controllers. Reuse the
nearest existing fixture and matcher style.

## Live layout

- controllers and feature behavior: `test/presentation/<feature>/`
- repositories: `test/repositories/`
- services: `test/services/`
- application models from `lib/models/`: `test/domain/`
- utilities: `test/utils/`
- fixtures and helpers: `test/test_data/`, `test/helpers/`
- broad widget smoke coverage: `test/widget_test.dart`

Confirm paths in the live `test/` tree. For a feature, use
`lib/manifests/<feature>.manifest.generated.json` as a discovery index, then
verify `testing.testFiles` and `testing.runCommand` before relying on them.

## Execution

Run the narrowest relevant path while iterating:

```bash
flutter test test/presentation/login/
```

Run the full suite only when root `AGENTS.md` requires it. CI behavior is owned
by the live workflow under `.github/workflows/`, not this document.
