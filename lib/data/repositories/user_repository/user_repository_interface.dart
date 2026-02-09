import 'package:riverpod_template/models/user/user.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';

abstract interface class UserRepositoryInterface {
  Future<User> fetchUserData(int id);

  Future<List<User>> fetchSomeUsers();

  /// Sends user profile data to the server.
  Future<NetworkResponse> updateUserData({required Map<String, dynamic> formData});
}
