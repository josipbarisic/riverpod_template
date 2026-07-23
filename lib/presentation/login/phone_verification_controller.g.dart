// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_verification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controls the phone number verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData(verificationId)` — SMS code sent, pass this ID to verify
/// - `AsyncLoading` — sending or verifying
/// - `AsyncError` — failed with user-friendly message

@ProviderFor(PhoneVerificationController)
const phoneVerificationControllerProvider =
    PhoneVerificationControllerProvider._();

/// Controls the phone number verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData(verificationId)` — SMS code sent, pass this ID to verify
/// - `AsyncLoading` — sending or verifying
/// - `AsyncError` — failed with user-friendly message
final class PhoneVerificationControllerProvider
    extends $AsyncNotifierProvider<PhoneVerificationController, String?> {
  /// Controls the phone number verification flow.
  ///
  /// State semantics:
  /// - `AsyncData(null)` — initial / idle
  /// - `AsyncData(verificationId)` — SMS code sent, pass this ID to verify
  /// - `AsyncLoading` — sending or verifying
  /// - `AsyncError` — failed with user-friendly message
  const PhoneVerificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneVerificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneVerificationControllerHash();

  @$internal
  @override
  PhoneVerificationController create() => PhoneVerificationController();
}

String _$phoneVerificationControllerHash() =>
    r'9b6ffeb58cf23251fc9a3ea7b50110b2580647d3';

/// Controls the phone number verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData(verificationId)` — SMS code sent, pass this ID to verify
/// - `AsyncLoading` — sending or verifying
/// - `AsyncError` — failed with user-friendly message

abstract class _$PhoneVerificationController extends $AsyncNotifier<String?> {
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
