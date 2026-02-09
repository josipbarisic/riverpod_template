/// Configuration for which authentication providers are enabled.
///
/// Set flags to `true` or `false` to control which providers
/// appear in your login/registration UI and are available in the auth flow.
///
/// Usage in views:
/// ```dart
/// if (AuthConfig.enableGoogleAuth) {
///   // Show Google sign-in button
/// }
/// ```
///
/// Usage in controllers:
/// ```dart
/// if (!AuthConfig.isProviderEnabled(SignInProvider.phone)) {
///   throw UnsupportedError('Phone auth is disabled');
/// }
/// ```
class AuthConfig {
  AuthConfig._();

  // -------------------- Provider Toggles --------------------

  /// Email + password authentication.
  static const bool enableEmailAuth = true;

  /// Phone number authentication (Firebase phone auth).
  static const bool enablePhoneAuth = true;

  /// Google Sign-In.
  static const bool enableGoogleAuth = true;

  /// Apple Sign-In.
  static const bool enableAppleAuth = true;

  /// Facebook Login.
  static const bool enableFacebookAuth = false;

  // -------------------- Feature Toggles --------------------

  /// Whether to show the "Forgot Password" link on the login screen.
  static const bool enableForgotPassword = true;

  /// Whether to require email verification after sign-up.
  static const bool requireEmailVerification = false;

  /// Whether to require phone verification after sign-up.
  static const bool requirePhoneVerification = false;

  /// Whether to show the profile completion step after sign-up.
  static const bool requireProfileCompletion = true;

  // -------------------- Helpers --------------------

  /// Returns the list of enabled social providers.
  static List<String> get enabledSocialProviders => [
        if (enableGoogleAuth) 'google',
        if (enableAppleAuth) 'apple',
        if (enableFacebookAuth) 'facebook',
      ];

  /// Whether any social provider is enabled.
  static bool get hasSocialProviders => enabledSocialProviders.isNotEmpty;

  /// Check if a specific provider string is enabled.
  static bool isProviderEnabled(String providerId) => switch (providerId) {
        'password' => enableEmailAuth,
        'phone' => enablePhoneAuth,
        'google.com' => enableGoogleAuth,
        'apple.com' => enableAppleAuth,
        'facebook.com' => enableFacebookAuth,
        _ => false,
      };
}
