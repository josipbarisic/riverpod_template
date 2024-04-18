import 'package:riverpod_template/domain/user/user.dart';

abstract interface class UserRepositoryInterface {
  Future<User> fetchUserData(int id);

  Future<Object> fetchSomeUsers();
}
