import 'package:riverpod_template/domain/user/user.dart';

abstract class AuthRepositoryInterface {
  // emits a new value every time the authentication state changes
  Stream<User?> authStateChanges();

  Future<User> signInAnonymously();

  Future<void> signOut();
}