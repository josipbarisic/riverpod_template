import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_interface.dart';
import 'package:riverpod_template/models/user/user.dart' as domain;
import 'package:riverpod_template/core/utils/app_strings.dart';
import 'package:riverpod_template/core/extensions/user_extensions.dart';
import 'package:riverpod_template/core/mixins/firebase_auth_mixin.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository with FirebaseAuthMixin implements AuthRepositoryInterface {

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
      return NetworkSuccessResponse(data: user.toDomainUser());
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
          .then<NetworkResponse>((user) => NetworkSuccessResponse(data: user.toDomainUser()))
          .onError((error, _) {
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
          .then<NetworkResponse>((user) => NetworkSuccessResponse(data: user.toDomainUser()))
          .onError((error, _) => NetworkErrorResponse(
                httpStatusCode: 401,
                message: error.toString(),
              ));

  // ---------------------------- Email/Password Auth ----------------------------
  @override
  Future<NetworkResponse> createUserWithEmailAndPassword(String email, String password) =>
      firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((cred) => cred.user ?? (throw Exception(ErrorStrings.failedToCreateUser)))
          .then<NetworkResponse>((user) => NetworkSuccessResponse(
                data: user.toDomainUser(),
              ))
          .onError((error, _) => NetworkErrorResponse(
                httpStatusCode: 401,
                message: error.toString(),
              ));

  @override
  Future<NetworkResponse> signInWithEmailAndPassword(String email, String password) => firebaseAuth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((cred) => cred.user ?? (throw Exception(ErrorStrings.failedToCreateUser)))
      .then<NetworkResponse>((user) => NetworkSuccessResponse(
            data: user.toDomainUser(),
          ))
      .onError((error, _) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: error.toString(),
          ));

  @override
  Future<NetworkResponse> initEmailVerification() => firebaseAuth.currentUser!
      .sendEmailVerification()
      .then<NetworkResponse>((value) => NetworkSuccessResponse())
      .onError((error, _) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: error.toString(),
          ));

  @override
  Future<NetworkResponse> verifyEmail(String code) {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }

  @override
  Future<NetworkResponse> checkEmailVerificationStatus() => firebaseAuth.currentUser!
      .reload()
      .then<NetworkResponse>(
          (_) => NetworkSuccessResponse(data: firebaseAuth.currentUser!.emailVerified))
      .onError((error, _) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: error.toString(),
          ));

  @override
  Future<NetworkResponse> initPhoneNumberVerification(String phoneNumber) => firebaseAuth
      .verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          log('Phone verification completed: $phoneAuthCredential');
        },
        verificationFailed: (error) {
          log('Phone verification failed: $error');
        },
        codeSent: (verificationId, resendToken) {
          log('Phone verification code sent: $verificationId');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          log('Phone verification code auto retrieval timeout: $verificationId');
        },
      )
      .then<NetworkResponse>((value) => NetworkSuccessResponse())
      .onError((error, _) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: error.toString(),
          ));

  @override
  Future<NetworkResponse> verifyPhoneNumber(String code) {
    // TODO: implement verifyPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<NetworkResponse> signOut() =>
      // TODO(Josip): Adjust the sign out method to include all providers
      firebaseAuth.signOut().then((_) => GoogleSignIn.instance.signOut()).then<NetworkResponse>((_) {
        log('User signed out');
        return NetworkSuccessResponse();
      }).catchError((e) => NetworkErrorResponse(
            httpStatusCode: 401,
            message: 'Failed to sign out.',
          ));
}
