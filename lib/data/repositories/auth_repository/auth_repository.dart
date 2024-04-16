import 'dart:developer';

import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_interface.dart';
import 'package:riverpod_template/domain/user/user.dart';

class AuthRepository implements AuthRepositoryInterface {
  @override
  Stream<User?> authStateChanges() async* {
    yield const User(id: 1, username: 'user', email: 'user@email.com');
  }

  @override
  Future<User> signInAnonymously() async {
    return const User(id: 2, username: 'anon', email: 'anon@email.com');
  }

  @override
  Future<void> signOut() async {
    log('====== Signing out =========');
  }
}
