import 'dart:developer';

import 'package:riverpod_template/data/repositories/user_repository/user_repository_interface.dart';
import 'package:riverpod_template/domain/user/user.dart';
import 'package:riverpod_template/services/network_service/network_service.dart';
import 'package:riverpod_template/utils/network/endpoints.dart';

class UserRepository implements UserRepositoryInterface {
  UserRepository({
    required this.networkService,
  });

  final NetworkService networkService;

  @override
  Future<User> fetchUserData(int id) async {
    var response = await networkService.getHttp(endpoint: Endpoints.user(id));

    try {
      return User.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      log('Parsing user json failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<User>> fetchSomeUsers() async {
    var response = await networkService.getHttp(endpoint: Endpoints.users);

    List<User> users = [];

    try {
      users = (response.data as List<dynamic>).map((e) => User.fromJson(e)).toList();
    } catch (e) {
      log('Parsing users json failed: $e');
    }

    return users;
  }
}
