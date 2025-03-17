import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/data/repositories/user_repository/user_repository.dart';
import 'package:riverpod_template/domain/user/user.dart';
import 'package:riverpod_template/services/network_service/network_service_providers.dart';

part 'user_repository_providers.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) =>
    UserRepository(networkService: ref.watch(networkServiceProvider));

@riverpod
Future<User> userData(Ref ref, int id) => ref.watch(userRepositoryProvider).fetchUserData(id);

@riverpod
Future<List<User>> someUsers(Ref ref) => ref.watch(userRepositoryProvider).fetchSomeUsers();
