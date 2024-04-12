import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// Run "dart run build_runner build -d" to start code generation
@freezed
class User with _$User {
  const factory User({
    required String uid,
    required String username,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
