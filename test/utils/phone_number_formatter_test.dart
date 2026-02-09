import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/core/utils/input_formatters/phone_number_formatter.dart';

void main() {
  group('PhoneNumberFormatter', () {
    group('toE164Format', () {
      test('cleans formatted US number', () {
        expect(
          PhoneNumberFormatter.toE164Format('+1 (222)222-2222'),
          equals('+12222222222'),
        );
      });

      test('preserves already clean number', () {
        expect(
          PhoneNumberFormatter.toE164Format('+12222222222'),
          equals('+12222222222'),
        );
      });

      test('adds + prefix when missing', () {
        expect(
          PhoneNumberFormatter.toE164Format('12222222222'),
          equals('+12222222222'),
        );
      });

      test('handles international number', () {
        expect(
          PhoneNumberFormatter.toE164Format('+44 20 7946 0958'),
          equals('+442079460958'),
        );
      });

      test('removes all non-digit characters except +', () {
        expect(
          PhoneNumberFormatter.toE164Format('+1-(800) 555-1234'),
          equals('+18005551234'),
        );
      });
    });

    group('formatUsPhoneNumber', () {
      test('formats 10-digit number correctly', () {
        expect(
          PhoneNumberFormatter.formatUsPhoneNumber('7193981666'),
          equals('+1(719)398-1666'),
        );
      });

      test('formats 11-digit number starting with 1', () {
        expect(
          PhoneNumberFormatter.formatUsPhoneNumber('17193981666'),
          equals('+1(719)398-1666'),
        );
      });

      test('formats number with + prefix', () {
        expect(
          PhoneNumberFormatter.formatUsPhoneNumber('+17193981666'),
          equals('+1(719)398-1666'),
        );
      });

      test('formats dirty formatted number', () {
        expect(
          PhoneNumberFormatter.formatUsPhoneNumber('(719) 398-1666'),
          equals('+1(719)398-1666'),
        );
      });

      test('returns original for non-US number (too short)', () {
        expect(
          PhoneNumberFormatter.formatUsPhoneNumber('12345'),
          equals('12345'),
        );
      });

      test('returns original for non-US number (too long)', () {
        expect(
          PhoneNumberFormatter.formatUsPhoneNumber('123456789012345'),
          equals('123456789012345'),
        );
      });

      test('returns original for number not starting with 1 (11 digits)', () {
        expect(
          PhoneNumberFormatter.formatUsPhoneNumber('27193981666'),
          equals('27193981666'),
        );
      });
    });
  });
}
