import 'package:riverpod_template/models/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_handler.g.dart';

/// Global user state provider. Keeps the current user alive across
/// the entire app lifecycle so any feature can check auth state.
@Riverpod(keepAlive: true)
class UserHandler extends _$UserHandler {
  @override
  User? build() => null;

  void setUser(User? user) => state = user;
}
