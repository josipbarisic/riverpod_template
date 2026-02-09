import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_template/core/utils/user_handler/user_handler.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_interface.dart';
import 'package:riverpod_template/models/user/user.dart' as domain;
import 'package:riverpod_template/core/utils/app_strings.dart';
import 'package:riverpod_template/core/extensions/user_extensions.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository({
    required this.firebaseAuth,
    required this.firebaseMessaging,
    required this.userHandler,
    this.onSignOutCallback,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseMessaging firebaseMessaging;
  final UserHandler userHandler;

  /// Optional callback invoked after sign-out completes.
  /// Use to invalidate providers, clear badges, etc.
  final VoidCallback? onSignOutCallback;

  @override
  User? get currentUser => firebaseAuth.currentUser;

  @override
  Stream<domain.User?> authStateChanges() =>
      firebaseAuth.authStateChanges().map((user) => user?.toDomainUser());

  // ---------------------------- Social Login Methods ----------------------------
  // Social login methods require separate setup for each provider. Instructions are available
  // in the following sources:
  //   - https://firebase.flutter.dev/docs/auth/social/
  //   - https://pub.dev/packages/sign_in_with_apple
  //   - https://pub.dev/packages/google_sign_in
  //   - https://pub.dev/packages/facebook_auth

  @override
  Future<NetworkResponse> continueWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final authorization = await googleUser.authorizationClient.authorizationForScopes([]);

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization?.accessToken,
      );

      final cred = await firebaseAuth.signInWithCredential(credential);
      final user = cred.user ?? (throw Exception(ErrorStrings.failedToAuthenticateUser));
      final domainUser = user.toDomainUser();
      userHandler.setUser(domainUser);
      return NetworkSuccessResponse(data: domainUser);
    } catch (error) {
      return NetworkErrorResponse(
        httpStatusCode: 401,
        message: error.toString(),
      );
    }
  }

  @override
  Future<NetworkResponse> continueWithApple() => firebaseAuth
          .signInWithProvider(AppleAuthProvider()..addScope(AppleIDAuthorizationScopes.email.name))
          .then((cred) => cred.user ?? (throw Exception(ErrorStrings.failedToAuthenticateUser)))
          .then<NetworkResponse>((user) {
        final domainUser = user.toDomainUser();
        userHandler.setUser(domainUser);
        return NetworkSuccessResponse(data: domainUser);
      }).onError((error, _) {
        log('Error with Apple sign in: $error');
        return NetworkErrorResponse(
          httpStatusCode: 401,
          message: error.toString(),
        );
      });

  @override
  Future<NetworkResponse> continueWithFacebook() =>
      // Trigger the Facebook authentication flow
      FacebookAuth.instance
          .login()
          .then((result) {
            final accessToken = result.accessToken!.tokenString;
            final facebookAuthCredential = FacebookAuthProvider.credential(accessToken);
            // Sign in with the Facebook credentials
            return firebaseAuth.signInWithCredential(facebookAuthCredential);
          })
          .then((cred) => cred.user ?? (throw Exception(ErrorStrings.failedToAuthenticateUser)))
          .then<NetworkResponse>((user) {
        final domainUser = user.toDomainUser();
        userHandler.setUser(domainUser);
        return NetworkSuccessResponse(data: domainUser);
      }).onError((error, _) => NetworkErrorResponse(
                httpStatusCode: 401,
                message: error.toString(),
              ));

  // ---------------------------- Email/Password Auth ----------------------------
  @override
  Future<NetworkResponse> createUserWithEmailAndPassword(String email, String password) =>
      firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((cred) => cred.user ?? (throw Exception(ErrorStrings.failedToCreateUser)))
          .then<NetworkResponse>((user) {
        final domainUser = user.toDomainUser();
        userHandler.setUser(domainUser);
        return NetworkSuccessResponse(data: domainUser);
      }).onError((error, _) => NetworkErrorResponse(
                httpStatusCode: 401,
                message: error.toString(),
              ));

  @override
  Future<NetworkResponse> signInWithEmailAndPassword(String email, String password) => firebaseAuth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((cred) => cred.user ?? (throw Exception(ErrorStrings.failedToCreateUser)))
      .then<NetworkResponse>((user) {
        final domainUser = user.toDomainUser();
        userHandler.setUser(domainUser);
        return NetworkSuccessResponse(data: domainUser);
      })
      .onError((error, _) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: error.toString(),
          ));

  // ---------------------------- Password Reset ----------------------------
  @override
  Future<NetworkResponse> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return NetworkSuccessResponse();
    } catch (e) {
      log('Error sending password reset email: $e');
      return NetworkErrorResponse(
        httpStatusCode: 400,
        message: e.toString(),
      );
    }
  }

  // ---------------------------- Email Verification ----------------------------
  @override
  Future<NetworkResponse> initEmailVerification() => firebaseAuth.currentUser!
      .sendEmailVerification()
      .then<NetworkResponse>((value) => NetworkSuccessResponse())
      .onError((error, _) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: error.toString(),
          ));

  @override
  Future<NetworkResponse> verifyEmail(String code) =>
      firebaseAuth
          .applyActionCode(code)
          .then((_) => firebaseAuth.currentUser!.reload())
          .then<NetworkResponse>((_) => NetworkSuccessResponse(
                data: firebaseAuth.currentUser!.emailVerified,
              ))
          .onError((error, _) => NetworkErrorResponse(
                httpStatusCode: 400,
                message: error.toString(),
              ));

  @override
  Future<NetworkResponse> checkEmailVerificationStatus() => firebaseAuth.currentUser!
      .reload()
      .then<NetworkResponse>(
          (_) => NetworkSuccessResponse(data: firebaseAuth.currentUser!.emailVerified))
      .onError((error, _) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: error.toString(),
          ));

  // ---------------------------- Phone Verification ----------------------------
  @override
  Future<NetworkResponse> initPhoneNumberVerification(String phoneNumber) {
    final completer = Completer<NetworkResponse>();

    firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        log('Phone verification completed: $phoneAuthCredential');
      },
      verificationFailed: (error) {
        log('Phone verification failed: $error');
        if (!completer.isCompleted) {
          completer.complete(NetworkErrorResponse(
            httpStatusCode: 400,
            message: error.message ?? ErrorStrings.enterValidPhoneNumber,
          ));
        }
      },
      codeSent: (verificationId, resendToken) {
        log('Phone verification code sent: $verificationId');
        if (!completer.isCompleted) {
          completer.complete(NetworkSuccessResponse(data: verificationId));
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log('Phone verification code auto retrieval timeout: $verificationId');
        if (!completer.isCompleted) {
          completer.complete(NetworkSuccessResponse(data: verificationId));
        }
      },
    );

    return completer.future;
  }

  @override
  Future<NetworkResponse> verifyPhoneNumber(String code) =>
      // Override with actual verification logic when backend is ready.
      // For Firebase-only auth, use PhoneAuthProvider.credential + signInWithCredential.
      throw UnimplementedError(
        'Implement phone verification with your backend or Firebase PhoneAuthProvider.',
      );

  // ---------------------------- Sign Out ----------------------------
  @override
  Future<NetworkResponse> signOut() async {
    try {
      await firebaseAuth.signOut();
      await firebaseMessaging.deleteToken();
      await GoogleSignIn.instance.signOut();
      userHandler.setUser(null);
      onSignOutCallback?.call();
      log('User signed out');
      return NetworkSuccessResponse();
    } catch (e) {
      log('Error signing out: $e');
      return NetworkErrorResponse(
        httpStatusCode: 401,
        message: ErrorStrings.failedToSignOut,
      );
    }
  }
}

/// Callback type for sign-out side effects.
typedef VoidCallback = void Function();
