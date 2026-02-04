import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_interface.dart';
import 'package:riverpod_template/models/user/user.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';

/// Mock implementation of [AuthRepositoryInterface] for testing.
///
/// Uses mocktail for mocking and provides stub methods for common scenarios.
///
/// Usage:
/// ```dart
/// final mockRepo = MockAuthRepository();
/// mockRepo.stubSignInSuccess(TestUsers.basic);
/// // or
/// mockRepo.stubSignInError(Exception('Invalid credentials'));
/// ```
class MockAuthRepository extends Mock implements AuthRepositoryInterface {
  final _authStateController = StreamController<User?>.broadcast();

  /// Stub successful sign in with email/password
  void stubSignInSuccess(User user) {
    when(() => signInWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => NetworkSuccessResponse(data: user));
  }

  /// Stub failed sign in with email/password
  void stubSignInError(String message) {
    when(() => signInWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => NetworkErrorResponse(
              httpStatusCode: 401,
              message: message,
            ));
  }

  /// Stub successful user creation
  void stubCreateUserSuccess(User user) {
    when(() => createUserWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => NetworkSuccessResponse(data: user));
  }

  /// Stub failed user creation
  void stubCreateUserError(String message) {
    when(() => createUserWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => NetworkErrorResponse(
              httpStatusCode: 400,
              message: message,
            ));
  }

  /// Stub auth state changes stream
  void stubAuthStateChanges(List<User?> users) {
    when(() => authStateChanges()).thenAnswer((_) => _authStateController.stream);
    for (final user in users) {
      _authStateController.add(user);
    }
  }

  /// Emit a user to the auth state stream
  void emitAuthState(User? user) {
    _authStateController.add(user);
  }

  /// Stub successful Google sign in
  void stubGoogleSignInSuccess(User user) {
    when(() => continueWithGoogle())
        .thenAnswer((_) async => NetworkSuccessResponse(data: user));
  }

  /// Stub failed Google sign in
  void stubGoogleSignInError(String message) {
    when(() => continueWithGoogle())
        .thenAnswer((_) async => NetworkErrorResponse(
              httpStatusCode: 401,
              message: message,
            ));
  }

  /// Stub successful Apple sign in
  void stubAppleSignInSuccess(User user) {
    when(() => continueWithApple())
        .thenAnswer((_) async => NetworkSuccessResponse(data: user));
  }

  /// Stub successful sign out
  void stubSignOutSuccess() {
    when(() => signOut()).thenAnswer((_) async => NetworkSuccessResponse());
  }

  /// Stub failed sign out
  void stubSignOutError(String message) {
    when(() => signOut())
        .thenAnswer((_) async => NetworkErrorResponse(
              httpStatusCode: 500,
              message: message,
            ));
  }

  /// Stub email verification init
  void stubInitEmailVerificationSuccess() {
    when(() => initEmailVerification())
        .thenAnswer((_) async => NetworkSuccessResponse());
  }

  /// Stub check email verification status
  void stubCheckEmailVerificationStatus(bool isVerified) {
    when(() => checkEmailVerificationStatus())
        .thenAnswer((_) async => NetworkSuccessResponse(data: isVerified));
  }

  /// Clean up the controller when done
  void dispose() {
    _authStateController.close();
  }
}
