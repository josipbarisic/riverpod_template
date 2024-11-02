import 'package:riverpod_template/domain/user/user.dart';
import 'package:riverpod_template/utils/network/network_response.dart';

abstract interface class UserRepositoryInterface {
  Future<User> fetchUserData(int id);

  Future<Object> fetchSomeUsers();

  /// Sends the user data to the server.
  Future<NetworkResponse> updateUserData(User user);
}
