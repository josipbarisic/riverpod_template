/// Utility for formatting phone numbers to E.164 and display formats.
class PhoneNumberFormatter {
  /// Cleans a phone number to E.164 format for Firebase/API usage.
  ///
  /// Removes all non-numeric characters except the '+' sign and ensures
  /// the number starts with '+'.
  ///
  /// Examples:
  /// - '+1 (222)222-2222' -> '+12222222222'
  /// - '(222) 222-2222' -> '+12222222222' (assumes +1 prepend)
  /// - '+44 20 7946 0958' -> '+442079460958'
  static String toE164Format(String phoneNumber) {
    final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    return cleanPhoneNumber.startsWith('+') ? cleanPhoneNumber : '+$cleanPhoneNumber';
  }

  /// Formats a US phone number into +1(XXX)XXX-XXXX display format.
  ///
  /// Supported inputs:
  /// - +17193981666
  /// - 7193981666 (10 digits)
  /// - 17193981666 (1 + 10 digits)
  /// - (719) 398-1666 (formatted string)
  ///
  /// Returns the formatted string, or the original input if the number
  /// cannot be normalized into a standard US 10-digit number.
  static String formatUsPhoneNumber(String number) {
    String cleaned = number.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length == 10) {
      cleaned = '1$cleaned';
    } else if (cleaned.length == 11 && cleaned.startsWith('1')) {
      // Already correct
    } else {
      return number;
    }

    if (cleaned.length != 11) return number;

    final finalNumber = '+$cleaned';

    try {
      return '${finalNumber.substring(0, 2)}(${finalNumber.substring(2, 5)})${finalNumber.substring(5, 8)}-${finalNumber.substring(8, 12)}';
    } catch (_) {
      return number;
    }
  }
}
