import 'dart:developer';

import 'package:riverpod_template/core/config/auth_config.dart';
import 'package:riverpod_template/core/enums/sign_in_provider_enum.dart';
import 'package:riverpod_template/core/utils/app_strings.dart';
import 'package:riverpod_template/core/utils/helpers/firebase_error_helper.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_providers.dart';
import 'package:riverpod_template/presentation/login/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

/// Controls the login flow for all supported providers.
///
/// Respects [AuthConfig] toggles — if a provider is disabled,
/// `onSubmit` will set an error state instead of attempting sign-in.
///
/// Usage in a view:
/// ```dart
/// ref.read(loginControllerProvider.notifier).onSubmit(
///   provider: SignInProvider.email,
///   email: emailController.text,
///   password: passwordController.text,
/// );
/// ```
@Riverpod(keepAlive: true)
class LoginController extends _$LoginController {
  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  @override
  Future<LoginState> build() async => const LoginState();

  /// Resets controller state to initial values.
  /// Call after successful login to clear auth state for security/hygiene.
  void reset() {
    state = const AsyncData(LoginState());
  }

  /// Unified entry point for all sign-in providers.
  ///
  /// Checks [AuthConfig] before attempting sign-in.
  Future<void> onSubmit({
    required SignInProvider provider,
    String? email,
    String? password,
  }) async {
    // Guard: check if the provider is enabled
    if (!AuthConfig.isProviderEnabled(provider.providerId)) {
      state = AsyncError('${provider.name} sign-in is not enabled.', StackTrace.current);
      return;
    }

    state = AsyncData(LoginState(selectedProvider: provider));
    state = const AsyncLoading();

    await (switch (provider) {
      SignInProvider.google => continueWithGoogle(),
      SignInProvider.apple => continueWithApple(),
      SignInProvider.phone => continueWithPhoneNumber(phoneNumber: email ?? ''),
      SignInProvider.email =>
        continueWithEmailAndPassword(email: email ?? '', password: password ?? ''),
    })
        .catchError((Object e, StackTrace st) {
      log('Error signing in with $provider: $e');
      final errorMessage = FirebaseErrorHelper.getFirebaseErrorMessage(
        e,
        fallbackMessage: ErrorStrings.failedToAuthenticateUser,
      );
      state = AsyncError(errorMessage, st);
    });
  }

  Future<String?> continueWithPhoneNumber({required String phoneNumber}) async {
    state = AsyncData(LoginState(selectedProvider: SignInProvider.phone));
    state = const AsyncLoading();

    final result = await _authRepo.initPhoneNumberVerification(phoneNumber);

    if (result.httpStatusCode == 200) {
      state = AsyncData(LoginState(selectedProvider: SignInProvider.phone));
      return result.data as String?;
    } else {
      state = AsyncError(result.message, StackTrace.current);
      return null;
    }
  }

  Future<void> continueWithGoogle() async {
    final result = await _authRepo.continueWithGoogle();
    if (result.httpStatusCode == 200) {
      state = const AsyncData(LoginState(isAuthSuccess: true));
    } else {
      throw Exception(result.message);
    }
  }

  Future<void> continueWithApple() async {
    final result = await _authRepo.continueWithApple();
    if (result.httpStatusCode == 200) {
      state = const AsyncData(LoginState(isAuthSuccess: true));
    } else {
      throw Exception(result.message);
    }
  }

  Future<void> continueWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final result = await _authRepo.signInWithEmailAndPassword(email, password);
    if (result.httpStatusCode == 200) {
      state = const AsyncData(LoginState(isAuthSuccess: true));
    } else {
      state = AsyncError(result.message, StackTrace.current);
    }
  }
}
