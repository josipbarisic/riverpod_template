import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/core/config/auth_config.dart';
import 'package:riverpod_template/core/enums/registration_step_enum.dart';
import 'package:riverpod_template/core/enums/sign_in_provider_enum.dart';
import 'package:riverpod_template/core/utils/app_strings.dart';
import 'package:riverpod_template/core/utils/helpers/firebase_error_helper.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_providers.dart';

part 'registration_controller.g.dart';

/// Controls the registration/sign-up flow.
///
/// Determines the next [RegistrationStep] based on [AuthConfig] toggles,
/// making the registration flow fully modular.
///
/// State semantics:
/// - `AsyncData(step)` — current registration step
/// - `AsyncLoading` — processing
/// - `AsyncError` — failed with user-friendly message
@Riverpod(keepAlive: true)
class RegistrationController extends _$RegistrationController {
  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  @override
  FutureOr<RegistrationStep> build() => _determineFirstStep();

  /// Creates an account with email + password, then advances to the next step.
  Future<void> createAccountWithEmail({
    required String email,
    required String password,
  }) async {
    if (!AuthConfig.enableEmailAuth) {
      state = AsyncError('Email registration is not enabled.', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final result = await _authRepo.createUserWithEmailAndPassword(email, password);

    if (!ref.mounted) return;

    if (result.httpStatusCode == 200) {
      state = AsyncData(_determineFirstStep());
    } else {
      log('Registration failed: ${result.message}');
      state = AsyncError(result.message, StackTrace.current);
    }
  }

  /// Creates an account via a social provider (Google/Apple).
  Future<void> createAccountWithSocial(SignInProvider provider) async {
    if (!AuthConfig.isProviderEnabled(provider.providerId)) {
      state = AsyncError('${provider.name} is not enabled.', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    try {
      final result = switch (provider) {
        SignInProvider.google => await _authRepo.continueWithGoogle(),
        SignInProvider.apple => await _authRepo.continueWithApple(),
        _ => throw UnsupportedError('$provider not supported for social registration'),
      };

      if (!ref.mounted) return;

      if (result.httpStatusCode == 200) {
        state = AsyncData(_determineFirstStep());
      } else {
        state = AsyncError(result.message, StackTrace.current);
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = AsyncError(
        FirebaseErrorHelper.getFirebaseErrorMessage(
          e,
          fallbackMessage: ErrorStrings.failedToCreateUser,
        ),
        StackTrace.current,
      );
    }
  }

  /// Advances to the next registration step.
  void advanceToNextStep() {
    final currentStep = state.value;
    if (currentStep == null) return;

    final nextStep = _getNextStep(currentStep);
    state = AsyncData(nextStep);
  }

  /// Determines the first required step based on [AuthConfig].
  static RegistrationStep _determineFirstStep() {
    if (AuthConfig.requireEmailVerification) return RegistrationStep.verifyEmail;
    if (AuthConfig.requirePhoneVerification) return RegistrationStep.verifyPhone;
    if (AuthConfig.requireProfileCompletion) return RegistrationStep.completeProfile;
    return RegistrationStep.completed;
  }

  /// Gets the next step after [current], skipping disabled steps.
  RegistrationStep _getNextStep(RegistrationStep current) {
    final allSteps = RegistrationStep.values;
    final currentIndex = allSteps.indexOf(current);

    for (var i = currentIndex + 1; i < allSteps.length; i++) {
      final step = allSteps[i];
      if (_isStepEnabled(step)) return step;
    }

    return RegistrationStep.completed;
  }

  /// Whether a registration step is enabled in [AuthConfig].
  bool _isStepEnabled(RegistrationStep step) => switch (step) {
        RegistrationStep.verifyEmail => AuthConfig.requireEmailVerification,
        RegistrationStep.verifyPhone => AuthConfig.requirePhoneVerification,
        RegistrationStep.completeProfile => AuthConfig.requireProfileCompletion,
        RegistrationStep.completed => true,
      };
}
