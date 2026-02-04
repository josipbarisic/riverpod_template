import 'package:firebase_auth/firebase_auth.dart';

mixin FirebaseAuthMixin {
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  User? get firebaseUser => firebaseAuth.currentUser;

  bool get isSignedIn => firebaseUser != null;

  bool get isAnonymous => firebaseUser?.isAnonymous ?? true;

  bool get isGoogleLogin => firebaseUser?.providerData[0].providerId == 'google.com';

  bool get isAppleLogin => firebaseUser?.providerData[0].providerId == 'apple.com';

  bool get isSocialLogin => isGoogleLogin || isAppleLogin;

  String get userEmail =>
      firebaseUser?.providerData[0].email ?? firebaseUser?.email ?? 'Email Hidden';
}
