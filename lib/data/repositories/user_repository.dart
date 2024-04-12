import 'package:riverpod_template/data/models/user/user.dart';

abstract interface class UserRepositoryInterface {
  Future<User> fetchUserData(String uid);
}

class UserRepository implements UserRepositoryInterface {
  @override
  Future<User> fetchUserData(String uid) async => User();
}
