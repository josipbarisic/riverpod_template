import 'package:riverpod_template/utils/app_strings.dart';

class InputValidator {
  static String? validateEmail(String? value) {
    final regex = RegExp(r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');

    return value != null && value.isNotEmpty && !regex.hasMatch(value)
        ? ErrorStrings.enterValidEmail
        : null;
  }

  static String? validatePassword(String? value) {
    // If special characters are required in the password, add this (?=.*?[!@#$&*~]) to regex
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

    return value != null && value.isNotEmpty && !regex.hasMatch(value)
        ? ErrorStrings.enterValidPassword
        : null;
  }

  static String? validateRequiredTextField(String? value, {bool? extraCondition}) =>
      (value == null || value.isEmpty) && (extraCondition ?? true)
          ? ErrorStrings.mandatoryField
          : null;

  static String? validateDate(DateTime? value, {bool? extraCondition}) =>
      value == null && (extraCondition ?? true) ? ErrorStrings.mandatoryField : null;

  static bool isValidEmail(String email) => validateEmail(email) == null;

  static bool isValidPassword(String pass) => validatePassword(pass) == null;
}
