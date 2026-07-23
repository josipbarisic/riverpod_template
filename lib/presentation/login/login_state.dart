import 'package:equatable/equatable.dart';
import 'package:riverpod_template/core/enums/registration_step_enum.dart';
import 'package:riverpod_template/core/enums/sign_in_provider_enum.dart';

/// State for the login flow.
///
/// Tracks which provider was selected, whether auth succeeded,
/// and the next registration step (if the user hasn't completed registration).
class LoginState extends Equatable {
  const LoginState({
    this.selectedProvider,
    this.registrationStep,
    this.isAuthSuccess = false,
  });

  final SignInProvider? selectedProvider;
  final RegistrationStep? registrationStep;
  final bool isAuthSuccess;

  @override
  List<Object?> get props => [selectedProvider, registrationStep, isAuthSuccess];

  LoginState copyWith({
    SignInProvider? selectedProvider,
    RegistrationStep? registrationStep,
    bool? isAuthSuccess,
  }) =>
      LoginState(
        selectedProvider: selectedProvider ?? this.selectedProvider,
        registrationStep: registrationStep ?? this.registrationStep,
        isAuthSuccess: isAuthSuccess ?? this.isAuthSuccess,
      );
}
