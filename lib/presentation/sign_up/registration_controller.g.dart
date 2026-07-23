// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controls the registration/sign-up flow.
///
/// Determines the next [RegistrationStep] based on [AuthConfig] toggles,
/// making the registration flow fully modular.
///
/// State semantics:
/// - `AsyncData(step)` — current registration step
/// - `AsyncLoading` — processing
/// - `AsyncError` — failed with user-friendly message

@ProviderFor(RegistrationController)
const registrationControllerProvider = RegistrationControllerProvider._();

/// Controls the registration/sign-up flow.
///
/// Determines the next [RegistrationStep] based on [AuthConfig] toggles,
/// making the registration flow fully modular.
///
/// State semantics:
/// - `AsyncData(step)` — current registration step
/// - `AsyncLoading` — processing
/// - `AsyncError` — failed with user-friendly message
final class RegistrationControllerProvider
    extends $AsyncNotifierProvider<RegistrationController, RegistrationStep> {
  /// Controls the registration/sign-up flow.
  ///
  /// Determines the next [RegistrationStep] based on [AuthConfig] toggles,
  /// making the registration flow fully modular.
  ///
  /// State semantics:
  /// - `AsyncData(step)` — current registration step
  /// - `AsyncLoading` — processing
  /// - `AsyncError` — failed with user-friendly message
  const RegistrationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrationControllerHash();

  @$internal
  @override
  RegistrationController create() => RegistrationController();
}

String _$registrationControllerHash() =>
    r'25fd4fd3106f7efd76ed8f309e0207f78a26d837';

/// Controls the registration/sign-up flow.
///
/// Determines the next [RegistrationStep] based on [AuthConfig] toggles,
/// making the registration flow fully modular.
///
/// State semantics:
/// - `AsyncData(step)` — current registration step
/// - `AsyncLoading` — processing
/// - `AsyncError` — failed with user-friendly message

abstract class _$RegistrationController
    extends $AsyncNotifier<RegistrationStep> {
  FutureOr<RegistrationStep> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<RegistrationStep>, RegistrationStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RegistrationStep>, RegistrationStep>,
              AsyncValue<RegistrationStep>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
