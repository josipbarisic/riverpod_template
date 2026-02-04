import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({this.onUnauthorized, this.skipUnauthorizedPaths = const []});

  /// Callback triggered on 401 Unauthorized responses.
  /// Useful for handling session expiration and logout flows.
  final Future<void> Function()? onUnauthorized;

  /// List of endpoint paths that should skip the onUnauthorized callback.
  /// Useful for endpoints where 401 is expected (e.g., during registration).
  final List<String> skipUnauthorizedPaths;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: err.message ?? 'Connection timed out. Please check your internet connection.',
        ),
      DioExceptionType.badResponse => switch (err.response?.statusCode) {
          400 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: err.message ?? 'Bad request. Please check your input.',
              response: err.response,
            ),
          401 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: err.message ?? 'Unauthorized. Please login again.',
              response: err.response,
            ),
          403 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: err.message ?? 'Forbidden. You do not have access to this resource.',
              response: err.response,
            ),
          404 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: err.message ?? 'Resource not found.',
              response: err.response,
            ),
          500 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: err.message ?? 'Server error. Please try again later.',
              response: err.response,
            ),
          _ => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: err.message ?? 'An unexpected error occurred.',
              response: err.response,
            ),
        },
      DioExceptionType.cancel => DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: err.message ?? 'Request cancelled.',
        ),
      _ => DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: err.message ?? 'Network error occurred. Please check your connection.',
        ),
    };

    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 && onUnauthorized != null) {
      final requestPath = err.requestOptions.path;
      final shouldSkip = skipUnauthorizedPaths.any((path) => requestPath.contains(path));

      if (!shouldSkip) {
        onUnauthorized!().catchError((e) {
          // Silently handle errors during logout to prevent infinite loops
        });
      }
    }

    handler.next(error);
  }
}
