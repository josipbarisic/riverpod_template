import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/core/utils/helpers/firebase_error_helper.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_providers.dart';

part 'forgot_password_controller.g.dart';

/// Controls the forgot-password flow.
///
/// State semantics:
/// - `AsyncData(true)` — email sent successfully
/// - `AsyncData(false)` — initial / idle
/// - `AsyncLoading` — sending email
/// - `AsyncError` — failed with a user-friendly message
@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  FutureOr<bool> build() => false;

  /// Sends a password reset email to [email].
  Future<void> sendResetEmail(String email) async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).sendPasswordResetEmail(email: email);

    if (!ref.mounted) return;

    if (result.httpStatusCode == 200) {
      state = const AsyncData(true);
    } else {
      log('Password reset failed: ${result.message}');
      state = AsyncError(
        FirebaseErrorHelper.getFirebaseErrorMessage(result.message),
        StackTrace.current,
      );
    }
  }
}
