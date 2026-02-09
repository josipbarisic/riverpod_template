import 'package:riverpod_template/core/routing/app_route.dart';

/// Tracks multi-step registration progress.
///
/// Each step maps to a route so the app can resume registration
/// from where the user left off.
///
/// Add or remove steps as needed for your registration flow.
enum RegistrationStep {
  verifyEmail,
  verifyPhone,
  completeProfile,
  completed;

  /// Returns the route path this step should navigate to.
  String get routePath => switch (this) {
        RegistrationStep.verifyEmail => AppRoute.emailVerification,
        RegistrationStep.verifyPhone => AppRoute.phoneVerification,
        RegistrationStep.completeProfile => AppRoute.completeProfile,
        RegistrationStep.completed => AppRoute.bottomNavigation,
      };
}
