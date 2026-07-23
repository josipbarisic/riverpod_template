import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:riverpod_template/core/utils/user_handler/user_handler.dart';
import 'package:riverpod_template/data/repositories/user_repository/user_repository_interface.dart';
import 'package:riverpod_template/models/user/user.dart';
import 'package:riverpod_template/core/services/network_service/network_service.dart';
import 'package:riverpod_template/core/utils/network/endpoints.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';

class UserRepository implements UserRepositoryInterface {
  UserRepository({
    required this.networkService,
    required this.firebaseAuth,
    required this.userHandler,
  });

  final NetworkService networkService;
  final fb.FirebaseAuth firebaseAuth;
  final UserHandler userHandler;

  @override
  Future<User> fetchUserData(int id) async {
    final response = await networkService.getHttp(endpoint: Endpoints.user(id));

    try {
      final user = User.fromJson(response.data as Map<String, dynamic>);
      userHandler.setUser(user);
      return user;
    } catch (e) {
      log('Parsing user json failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<User>> fetchSomeUsers() async {
    final response = await networkService.getHttp(endpoint: Endpoints.users);

    List<User> users = [];

    try {
      users = (response.data as List<dynamic>).map((e) => User.fromJson(e)).toList();
    } catch (e) {
      log('Parsing users json failed: $e');
    }

    return users;
  }

  @override
  Future<NetworkResponse> updateUserData({required Map<String, dynamic> formData}) async =>
      networkService
          .postHttp(
            endpoint: Endpoints.users,
            headers: {'Authorization': 'Bearer ${await firebaseAuth.currentUser?.getIdToken()}'},
            body: formData,
          )
          .then<NetworkResponse>((response) {
        if (response.httpStatusCode == 200 && response.data != null) {
          userHandler.setUser(User.fromJson(response.data as Map<String, dynamic>));
        }
        return response;
      }).catchError((Object e) {
        log('Updating user data failed: $e');
        throw e;
      });
}
