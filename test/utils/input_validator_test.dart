import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/core/utils/app_strings.dart';
import 'package:riverpod_template/core/utils/input_validator.dart';

void main() {
  group('InputValidator', () {
    group('validateEmail', () {
      test('returns null for valid email', () {
        expect(InputValidator.validateEmail('test@example.com'), isNull);
      });

      test('returns null for complex valid email', () {
        expect(InputValidator.validateEmail('user.name+tag@domain.co.uk'), isNull);
      });

      test('returns error for invalid email format', () {
        expect(
          InputValidator.validateEmail('not-an-email'),
          equals(ErrorStrings.enterValidEmail),
        );
      });

      test('returns error for email without domain', () {
        expect(
          InputValidator.validateEmail('test@'),
          equals(ErrorStrings.enterValidEmail),
        );
      });

      test('returns mandatory field error for null when required', () {
        expect(
          InputValidator.validateEmail(null, isRequired: true),
          equals(ErrorStrings.mandatoryField),
        );
      });

      test('returns mandatory field error for empty when required', () {
        expect(
          InputValidator.validateEmail('', isRequired: true),
          equals(ErrorStrings.mandatoryField),
        );
      });

      test('returns null for empty when not required', () {
        expect(InputValidator.validateEmail('', isRequired: false), isNull);
      });

      test('returns null for null when not required', () {
        expect(InputValidator.validateEmail(null, isRequired: false), isNull);
      });
    });

    group('validatePassword', () {
      test('returns null for valid password', () {
        // At least 1 uppercase, 1 lowercase, 1 digit, 8+ chars
        expect(InputValidator.validatePassword('Password1'), isNull);
      });

      test('returns error for password without uppercase', () {
        expect(
          InputValidator.validatePassword('password1'),
          equals(ErrorStrings.enterValidPassword),
        );
      });

      test('returns error for password without lowercase', () {
        expect(
          InputValidator.validatePassword('PASSWORD1'),
          equals(ErrorStrings.enterValidPassword),
        );
      });

      test('returns error for password without digit', () {
        expect(
          InputValidator.validatePassword('Password'),
          equals(ErrorStrings.enterValidPassword),
        );
      });

      test('returns error for password shorter than 8 chars', () {
        expect(
          InputValidator.validatePassword('Pass1'),
          equals(ErrorStrings.enterValidPassword),
        );
      });

      test('returns mandatory field error for null', () {
        expect(
          InputValidator.validatePassword(null),
          equals(ErrorStrings.mandatoryField),
        );
      });

      test('returns mandatory field error for empty string', () {
        expect(
          InputValidator.validatePassword(''),
          equals(ErrorStrings.mandatoryField),
        );
      });
    });

    group('validateConfirmPassword', () {
      test('returns null when passwords match', () {
        expect(
          InputValidator.validateConfirmPassword('Password1', 'Password1'),
          isNull,
        );
      });

      test('returns error when passwords do not match', () {
        expect(
          InputValidator.validateConfirmPassword('Password1', 'Different1'),
          equals(ErrorStrings.passwordsDontMatch),
        );
      });

      test('returns mandatory field error for null confirm password', () {
        expect(
          InputValidator.validateConfirmPassword(null, 'Password1'),
          equals(ErrorStrings.passwordsDontMatch),
        );
      });
    });

    group('validateRequiredTextField', () {
      test('returns null for non-empty value', () {
        expect(InputValidator.validateRequiredTextField('hello'), isNull);
      });

      test('returns error for null value', () {
        expect(
          InputValidator.validateRequiredTextField(null),
          equals(ErrorStrings.mandatoryField),
        );
      });

      test('returns error for empty value', () {
        expect(
          InputValidator.validateRequiredTextField(''),
          equals(ErrorStrings.mandatoryField),
        );
      });

      test('returns null when extraCondition is false', () {
        expect(
          InputValidator.validateRequiredTextField(null, extraCondition: false),
          isNull,
        );
      });
    });

    group('validateDate', () {
      test('returns null for non-null date', () {
        expect(InputValidator.validateDate(DateTime.now()), isNull);
      });

      test('returns error for null date', () {
        expect(
          InputValidator.validateDate(null),
          equals(ErrorStrings.mandatoryField),
        );
      });

      test('returns null when extraCondition is false', () {
        expect(InputValidator.validateDate(null, extraCondition: false), isNull);
      });
    });

    group('convenience methods', () {
      test('isValidEmail returns true for valid email', () {
        expect(InputValidator.isValidEmail('test@example.com'), isTrue);
      });

      test('isValidEmail returns false for invalid email', () {
        expect(InputValidator.isValidEmail('not-an-email'), isFalse);
      });

      test('isValidPassword returns true for valid password', () {
        expect(InputValidator.isValidPassword('Password1'), isTrue);
      });

      test('isValidPassword returns false for invalid password', () {
        expect(InputValidator.isValidPassword('weak'), isFalse);
      });
    });
  });
}
