/// Typed error constants for use with [AsyncError] state.
///
/// Usage in controllers:
/// ```dart
/// state = AsyncError(StateErrors.UNSUPPORTED_APP_VERSION, StackTrace.current);
/// ```
///
/// Usage in views:
/// ```dart
/// if (state.error == StateErrors.UNSUPPORTED_APP_VERSION) { ... }
/// ```
enum StateErrors {
  UNSUPPORTED_APP_VERSION,
  UNAUTHENTICATED,
  NETWORK_ERROR,
}
