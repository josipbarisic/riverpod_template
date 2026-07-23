// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controls the forgot-password flow.
///
/// State semantics:
/// - `AsyncData(true)` — email sent successfully
/// - `AsyncData(false)` — initial / idle
/// - `AsyncLoading` — sending email
/// - `AsyncError` — failed with a user-friendly message

@ProviderFor(ForgotPasswordController)
const forgotPasswordControllerProvider = ForgotPasswordControllerProvider._();

/// Controls the forgot-password flow.
///
/// State semantics:
/// - `AsyncData(true)` — email sent successfully
/// - `AsyncData(false)` — initial / idle
/// - `AsyncLoading` — sending email
/// - `AsyncError` — failed with a user-friendly message
final class ForgotPasswordControllerProvider
    extends $AsyncNotifierProvider<ForgotPasswordController, bool> {
  /// Controls the forgot-password flow.
  ///
  /// State semantics:
  /// - `AsyncData(true)` — email sent successfully
  /// - `AsyncData(false)` — initial / idle
  /// - `AsyncLoading` — sending email
  /// - `AsyncError` — failed with a user-friendly message
  const ForgotPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordControllerHash();

  @$internal
  @override
  ForgotPasswordController create() => ForgotPasswordController();
}

String _$forgotPasswordControllerHash() =>
    r'88a3821867b686966681c1ca4fdd2ded6f064fad';

/// Controls the forgot-password flow.
///
/// State semantics:
/// - `AsyncData(true)` — email sent successfully
/// - `AsyncData(false)` — initial / idle
/// - `AsyncLoading` — sending email
/// - `AsyncError` — failed with a user-friendly message

abstract class _$ForgotPasswordController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
