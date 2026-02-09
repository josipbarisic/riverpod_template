// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(LoginController)
const loginControllerProvider = LoginControllerProvider._();

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
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, LoginState> {
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
  const LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'6b32f085ea193b913d9c2fcf73e21edd1b8eee0a';

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

abstract class _$LoginController extends $AsyncNotifier<LoginState> {
  FutureOr<LoginState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<LoginState>, LoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoginState>, LoginState>,
              AsyncValue<LoginState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
