import 'package:riverpod_template/data/models/user/user.dart';
import 'package:riverpod_template/template_mock_data/mocked_user_data.dart';

abstract interface class UserRepositoryInterface {
  Future<User> fetchUserData(String uid);
}

class UserRepository implements UserRepositoryInterface {
  @override
  Future<User> fetchUserData(String uid) async => User.fromJson(mockedUserDataResponse);
}
