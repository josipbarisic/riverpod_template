import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/domain/user/user.dart';

void main() {
  final faker = Faker();

  group('User', () {
    // Test split/Join method
    test('splitMapJoin transforms string correctly', () {
      final input = 'hello world and hello everyone else';

      final output = input.split(' ').skip(1).join(' ');
      print('$output');

      expect(output, 'world and hello everyone else');
    });

    test('instantiated with expected properties', () {
      final id = faker.guid.guid();
      final email = faker.internet.email();
      final firstName = faker.person.firstName();
      final lastName = faker.person.lastName();
      final firebaseUserId = faker.guid.guid();
      final createdAt = DateTime.now();
      final updatedAt = DateTime.now();
      final dob = DateTime(2000, 1, 1);
      final phoneNumber = faker.phoneNumber.us();
      const gender = 'Male';
      const verified = true;

      final user = User(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        firebaseUserId: firebaseUserId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        dob: dob,
        phoneNumber: phoneNumber,
        gender: gender,
        verified: verified,
      );

      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.firstName, equals(firstName));
      expect(user.lastName, equals(lastName));
      expect(user.firebaseUserId, equals(firebaseUserId));
      expect(user.createdAt, equals(createdAt));
      expect(user.updatedAt, equals(updatedAt));
      expect(user.dob, equals(dob));
      expect(user.phoneNumber, equals(phoneNumber));
      expect(user.gender, equals(gender));
      expect(user.verified, equals(verified));
    });

    test('converts to and from JSON', () {
      final originalUser = User(
        id: faker.guid.guid(),
        email: faker.internet.email(),
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        firebaseUserId: faker.guid.guid(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dob: DateTime(2000, 1, 1),
        phoneNumber: faker.phoneNumber.us(),
        gender: 'Male',
        verified: true,
      );

      final json = originalUser.toJson();
      final fromJsonUser = User.fromJson(json);

      expect(fromJsonUser, equals(originalUser));
    });

    test('is equal to another instance with the same properties', () {
      final id = faker.guid.guid();
      final email = faker.internet.email();
      final firstName = faker.person.firstName();
      final lastName = faker.person.lastName();
      final firebaseUserId = faker.guid.guid();
      final createdAt = DateTime.now();
      final updatedAt = DateTime.now();
      final dob = DateTime(2000, 1, 1);
      final phoneNumber = faker.phoneNumber.us();
      const gender = 'Male';
      const verified = true;

      final user1 = User(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        firebaseUserId: firebaseUserId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        dob: dob,
        phoneNumber: phoneNumber,
        gender: gender,
        verified: verified,
      );

      final user2 = User(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        firebaseUserId: firebaseUserId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        dob: dob,
        phoneNumber: phoneNumber,
        gender: gender,
        verified: verified,
      );

      expect(user1, equals(user2));
      assert(user1 == user2);
    });

    test('copyWith new properties', () {
      final originalUser = User(
        id: faker.guid.guid(),
        email: faker.internet.email(),
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        firebaseUserId: faker.guid.guid(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dob: DateTime(2000, 1, 1),
        phoneNumber: faker.phoneNumber.us(),
        gender: 'Male',
        verified: true,
      );

      final newUser = originalUser.copyWith(
        id: 'newId',
        email: 'newEmail',
      );

      expect(newUser.id, equals('newId'));
      expect(newUser.email, equals('newEmail'));
      assert(newUser != originalUser);
    });

    test('fromJson creates a User object', () {
      final id = faker.guid.guid();
      final email = faker.internet.email();
      final firstName = faker.person.firstName();
      final lastName = faker.person.lastName();
      final firebaseUserId = faker.guid.guid();
      final createdAt = DateTime.now();
      final updatedAt = DateTime.now();
      final dob = DateTime(2000, 1, 1);
      final phoneNumber = faker.phoneNumber.us();
      const gender = 'Male';
      const verified = true;

      final json = {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'firebaseUserId': firebaseUserId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'dob': dob.toIso8601String(),
        'phoneNumber': phoneNumber,
        'gender': gender,
        'verified': verified,
      };

      final user = User.fromJson(json);

      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.firstName, equals(firstName));
      expect(user.lastName, equals(lastName));
      expect(user.firebaseUserId, equals(firebaseUserId));
      expect(user.createdAt, equals(createdAt));
      expect(user.updatedAt, equals(updatedAt));
      expect(user.dob, equals(dob));
      expect(user.phoneNumber, equals(phoneNumber));
      expect(user.gender, equals(gender));
      expect(user.verified, equals(verified));
    });
  });
}
