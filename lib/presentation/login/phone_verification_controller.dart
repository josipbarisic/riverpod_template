import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/core/utils/helpers/firebase_error_helper.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_providers.dart';

part 'phone_verification_controller.g.dart';

/// Controls the phone number verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData(verificationId)` — SMS code sent, pass this ID to verify
/// - `AsyncLoading` — sending or verifying
/// - `AsyncError` — failed with user-friendly message
@riverpod
class PhoneVerificationController extends _$PhoneVerificationController {
  @override
  FutureOr<String?> build() => null;

  /// Sends a verification SMS to [phoneNumber].
  ///
  /// On success, state becomes `AsyncData(verificationId)`.
  Future<void> sendVerificationCode(String phoneNumber) async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).initPhoneNumberVerification(phoneNumber);

    if (!ref.mounted) return;

    if (result.httpStatusCode == 200) {
      state = AsyncData(result.data as String?);
    } else {
      log('Phone verification failed: ${result.message}');
      state = AsyncError(
        FirebaseErrorHelper.getFirebaseErrorMessage(result.message),
        StackTrace.current,
      );
    }
  }

  /// Verifies the phone number using the [code] received via SMS.
  ///
  /// Note: Implement the actual verification logic in your AuthRepository.
  Future<void> verifyCode(String code) async {
    state = const AsyncLoading();

    try {
      final result = await ref.read(authRepositoryProvider).verifyPhoneNumber(code);

      if (!ref.mounted) return;

      if (result.httpStatusCode == 200) {
        state = const AsyncData('verified');
      } else {
        state = AsyncError(result.message, StackTrace.current);
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = AsyncError(
        FirebaseErrorHelper.getFirebaseErrorMessage(e),
        StackTrace.current,
      );
    }
  }
}
