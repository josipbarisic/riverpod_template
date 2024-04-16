import 'dart:developer';

import 'package:riverpod_template/data/repositories/user_repository/user_repository_interface.dart';
import 'package:riverpod_template/domain/user/user.dart';
import 'package:riverpod_template/services/network_service/network_service.dart';
import 'package:riverpod_template/template_mock_data/mocked_user_data.dart';

class UserRepository implements UserRepositoryInterface {
  UserRepository({
    required this.networkService,
  });

  final NetworkService networkService;

  @override
  Future<User> fetchUserData(String uid) async => User.fromJson(mockedUserDataResponse);

  @override
  Future<List<User>> fetchSomeUsers() async {
    var response = await networkService.getHttp(
        baseURL: 'https://jsonplaceholder.typicode.com', endpoint: '/users');

    List<User> users = [];

    try {
      users = (response.data as List<dynamic>).map((e) => User.fromJson(e)).toList();
    } catch (e) {
      log('Parsing users json failed: $e');
    }

    return users;
  }
}
