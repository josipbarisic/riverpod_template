import 'package:riverpod_template/domain/user/user.dart';

/// Factory function to create test users with optional overrides
User createTestUser({
  String? id,
  String? email,
  String? firstName,
  String? lastName,
  String? firebaseUserId,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? dob,
  String? phoneNumber,
  String? gender,
  bool? verified,
}) =>
    User(
      id: id ?? 'test-user-id',
      email: email ?? 'test@example.com',
      firstName: firstName ?? 'Test',
      lastName: lastName ?? 'User',
      firebaseUserId: firebaseUserId ?? 'firebase-test-id',
      createdAt: createdAt ?? DateTime(2024, 1, 1),
      updatedAt: updatedAt,
      dob: dob,
      phoneNumber: phoneNumber,
      gender: gender,
      verified: verified ?? true,
    );

/// Pre-built test user constants for common scenarios
class TestUsers {
  TestUsers._();

  /// Basic verified user
  static User get basic => createTestUser();

  /// Unverified user
  static User get unverified => createTestUser(
        id: 'unverified-user',
        email: 'unverified@example.com',
        verified: false,
      );

  /// User with complete profile
  static User get complete => createTestUser(
        id: 'complete-user',
        email: 'complete@example.com',
        firstName: 'Complete',
        lastName: 'Profile',
        phoneNumber: '+1234567890',
        gender: 'male',
        dob: DateTime(1990, 5, 15),
        verified: true,
      );

  /// Generate a list of test users
  static List<User> list(int count) => List.generate(
        count,
        (i) => createTestUser(
          id: 'user-$i',
          email: 'user$i@example.com',
          firstName: 'User',
          lastName: '$i',
        ),
      );
}
