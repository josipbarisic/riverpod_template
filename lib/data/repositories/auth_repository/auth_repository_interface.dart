// import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_template/domain/user/user.dart';
import 'package:riverpod_template/utils/network/network_response.dart';

abstract class AuthRepositoryInterface {
  /// Returns a stream that allows you to listen to the authentication state changes.
  Stream<User?> authStateChanges();

  /// Creates a new user with the provided email and password.
  Future<NetworkResponse> createUserWithEmailAndPassword(String email, String password);

  /// Signs the user in with Google credentials. If the user does not exist, he/she is created.
  Future<NetworkResponse> continueWithGoogle();

  /// Signs the user in with Apple credentials. If the user does not exist, he/she is created.
  Future<NetworkResponse> continueWithApple();

  /// Signs the user in with Facebook credentials. If the user does not exist, he/she is created.
  Future<NetworkResponse> continueWithFacebook();

  /// Signs the user in with email and password.
  Future<NetworkResponse> signInWithEmailAndPassword(String email, String password);

  /// Sends an email verification to the user.
  Future<NetworkResponse> initEmailVerification();

  /// Verifies the email with the code sent to the user.
  Future<NetworkResponse> verifyEmail(String code);

  /// Checks the email verification status.
  Future<NetworkResponse> checkEmailVerificationStatus();

  /// Send the verification code/email to the user's phone number.
  Future<NetworkResponse> initPhoneNumberVerification(String phoneNumber);

  /// Verifies the phone number with the code sent to the user.
  Future<NetworkResponse> verifyPhoneNumber(String code);

  /// Signs the user out.
  Future<NetworkResponse> signOut();
}