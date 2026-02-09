import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_providers.dart';

part 'email_verification_controller.g.dart';

/// Controls the email verification flow.
///
/// State semantics:
/// - `AsyncData(null)` — initial / idle
/// - `AsyncData('sent')` — verification email sent
/// - `AsyncData('verified')` — email verified
/// - `AsyncLoading` — in progress
/// - `AsyncError` — failed with user-friendly message
@riverpod
class EmailVerificationController extends _$EmailVerificationController {
  @override
  FutureOr<String?> build() => null;

  /// Sends a verification email to the current user.
  Future<void> sendVerificationEmail() async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).initEmailVerification();

    if (!ref.mounted) return;

    if (result.httpStatusCode == 200) {
      state = const AsyncData('sent');
    } else {
      log('Send email verification failed: ${result.message}');
      state = AsyncError(result.message, StackTrace.current);
    }
  }

  /// Checks if the user's email has been verified.
  Future<void> checkVerificationStatus() async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).checkEmailVerificationStatus();

    if (!ref.mounted) return;

    if (result.httpStatusCode == 200 && result.data == true) {
      state = const AsyncData('verified');
    } else {
      state = const AsyncData('sent'); // Still pending
    }
  }

  /// Verifies the email using the action code from the verification link.
  Future<void> verifyWithCode(String code) async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).verifyEmail(code);

    if (!ref.mounted) return;

    if (result.httpStatusCode == 200) {
      state = const AsyncData('verified');
    } else {
      log('Email verification failed: ${result.message}');
      state = AsyncError(result.message, StackTrace.current);
    }
  }
}
