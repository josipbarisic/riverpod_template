// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controls the email verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData('sent')` — verification email sent
/// - `AsyncData('verified')` — email verified
/// - `AsyncLoading` — in progress
/// - `AsyncError` — failed with user-friendly message

@ProviderFor(EmailVerificationController)
const emailVerificationControllerProvider =
    EmailVerificationControllerProvider._();

/// Controls the email verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData('sent')` — verification email sent
/// - `AsyncData('verified')` — email verified
/// - `AsyncLoading` — in progress
/// - `AsyncError` — failed with user-friendly message
final class EmailVerificationControllerProvider
    extends $AsyncNotifierProvider<EmailVerificationController, String?> {
  /// Controls the email verification flow.
  ///
  /// State semantics:
  /// - `AsyncData(null)` — initial / idle
  /// - `AsyncData('sent')` — verification email sent
  /// - `AsyncData('verified')` — email verified
  /// - `AsyncLoading` — in progress
  /// - `AsyncError` — failed with user-friendly message
  const EmailVerificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailVerificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailVerificationControllerHash();

  @$internal
  @override
  EmailVerificationController create() => EmailVerificationController();
}

String _$emailVerificationControllerHash() =>
    r'cd2082ca0f999b35002f0c4fcc954aa60150b359';

/// Controls the email verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData('sent')` — verification email sent
/// - `AsyncData('verified')` — email verified
/// - `AsyncLoading` — in progress
/// - `AsyncError` — failed with user-friendly message

abstract class _$EmailVerificationController extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
