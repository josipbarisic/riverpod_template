import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/core/utils/app_strings.dart';
import 'package:riverpod_template/core/utils/helpers/firebase_error_helper.dart';

void main() {
  group('FirebaseErrorHelper', () {
    group('getFirebaseErrorMessage', () {
      test('returns fallback message for non-Firebase errors', () {
        final result = FirebaseErrorHelper.getFirebaseErrorMessage(
          Exception('random error'),
          fallbackMessage: 'Custom fallback',
        );
        expect(result, equals('Custom fallback'));
      });

      test('returns default fallback when no fallback provided', () {
        final result = FirebaseErrorHelper.getFirebaseErrorMessage(
          Exception('random error'),
        );
        expect(result, equals(ErrorStrings.somethingWentWrong));
      });

      test('returns error message for FirebaseAuthException', () {
        final error = FirebaseAuthException(
          code: 'too-many-requests',
          message: 'Too many requests. Try again later.',
        );

        final result = FirebaseErrorHelper.getFirebaseErrorMessage(error);
        expect(result, equals('Too many requests. Try again later.'));
      });

      test('returns fallback when error is a plain string', () {
        final result = FirebaseErrorHelper.getFirebaseErrorMessage(
          'string error',
          fallbackMessage: 'Fallback',
        );
        expect(result, equals('Fallback'));
      });

      test('returns null for non-FirebaseAuthException in phone check', () {
        final result =
            FirebaseErrorHelper.getUserFriendlyPhoneNumberError('string error');
        expect(result, isNull);
      });
    });

    group('getUserFriendlyPhoneNumberError', () {
      test('returns null for non-Firebase errors', () {
        final result =
            FirebaseErrorHelper.getUserFriendlyPhoneNumberError(Exception());
        expect(result, isNull);
      });

      test('detects invalid-phone-number error code', () {
        final error = FirebaseAuthException(
          code: 'invalid-phone-number',
          message: 'The phone number is invalid.',
        );

        final result =
            FirebaseErrorHelper.getUserFriendlyPhoneNumberError(error);
        expect(result, equals(ErrorStrings.enterValidPhoneNumber));
      });

      test('detects missing-phone-number error code', () {
        final error = FirebaseAuthException(
          code: 'missing-phone-number',
          message: 'Phone number is missing.',
        );

        final result =
            FirebaseErrorHelper.getUserFriendlyPhoneNumberError(error);
        expect(result, equals(ErrorStrings.enterValidPhoneNumber));
      });

      test('detects phone format error in message', () {
        final error = FirebaseAuthException(
          code: 'unknown',
          message: 'The phone number format is invalid.',
        );

        final result =
            FirebaseErrorHelper.getUserFriendlyPhoneNumberError(error);
        expect(result, equals(ErrorStrings.enterValidPhoneNumber));
      });

      test('detects E.164 format error in message', () {
        final error = FirebaseAuthException(
          code: 'unknown',
          message: 'Phone number must be in E.164 format.',
        );

        final result =
            FirebaseErrorHelper.getUserFriendlyPhoneNumberError(error);
        expect(result, equals(ErrorStrings.enterValidPhoneNumber));
      });

      test('returns null for unrelated FirebaseAuthException', () {
        final error = FirebaseAuthException(
          code: 'too-many-requests',
          message: 'Too many requests.',
        );

        final result =
            FirebaseErrorHelper.getUserFriendlyPhoneNumberError(error);
        expect(result, isNull);
      });

      test('phone error takes precedence in getFirebaseErrorMessage', () {
        final error = FirebaseAuthException(
          code: 'invalid-phone-number',
          message: 'Firebase internal message.',
        );

        final result = FirebaseErrorHelper.getFirebaseErrorMessage(error);
        expect(result, equals(ErrorStrings.enterValidPhoneNumber));
      });
    });
  });
}
