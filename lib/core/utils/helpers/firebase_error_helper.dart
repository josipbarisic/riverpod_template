import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_template/core/utils/app_strings.dart';

/// Helper class for handling Firebase Auth errors and converting them
/// to user-friendly error messages.
class FirebaseErrorHelper {
  /// Checks if the error is a phone number format error and returns
  /// a user-friendly error message.
  ///
  /// Firebase Auth uses the error code 'invalid-phone-number' for
  /// invalid phone number formats. This method also checks the error
  /// message for common phone number format error patterns.
  ///
  /// Returns a user-friendly error message if it's a phone number
  /// format error, otherwise returns null.
  static String? getUserFriendlyPhoneNumberError(Object? error) {
    if (error is! FirebaseAuthException) {
      return null;
    }

    final errorCode = error.code.toLowerCase();
    final errorMessage = error.message?.toLowerCase() ?? '';

    // Check for invalid phone number error codes
    if (errorCode == 'invalid-phone-number' || errorCode == 'missing-phone-number') {
      return ErrorStrings.enterValidPhoneNumber;
    }

    // Check for phone number format errors in the message
    if (errorMessage.contains('phone number') &&
        (errorMessage.contains('format') ||
            errorMessage.contains('incorrect') ||
            errorMessage.contains('invalid') ||
            errorMessage.contains('e.164') ||
            errorMessage.contains('e164'))) {
      return ErrorStrings.enterValidPhoneNumber;
    }

    return null;
  }

  /// Extracts the Firebase error message from a FirebaseAuthException,
  /// excluding the error code prefix (e.g., [firebase_auth/too-many-requests]).
  ///
  /// Returns the clean error message if available, otherwise returns the fallback message.
  static String getFirebaseErrorMessage(Object? error, {String? fallbackMessage}) {
    // Check for phone number format errors
    final phoneError = getUserFriendlyPhoneNumberError(error);
    if (phoneError != null) {
      return phoneError;
    }

    if (error is FirebaseAuthException && error.message != null) {
      return error.message!;
    } else {
      return fallbackMessage ?? ErrorStrings.somethingWentWrong;
    }
  }
}
