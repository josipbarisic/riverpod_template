import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// Run "dart run build_runner build -d" to start code generation
@Freezed(copyWith: true, toJson: true, toStringOverride: true)
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    // Remove if Firebase is not used
    required String firebaseUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dob,
    String? phoneNumber,
    String? gender,
    bool? verified,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
