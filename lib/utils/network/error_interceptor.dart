import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: 'Connection timed out. Please check your internet connection.',
        ),
      DioExceptionType.badResponse => switch (err.response?.statusCode) {
          400 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: 'Bad request. Please check your input.',
              response: err.response,
            ),
          401 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: 'Unauthorized. Please login again.',
              response: err.response,
            ),
          403 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: 'Forbidden. You do not have access to this resource.',
              response: err.response,
            ),
          404 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: 'Resource not found.',
              response: err.response,
            ),
          500 => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: 'Server error. Please try again later.',
              response: err.response,
            ),
          _ => DioException(
              requestOptions: err.requestOptions,
              type: err.type,
              message: 'An unexpected error occurred.',
              response: err.response,
            ),
        },
      DioExceptionType.cancel => DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: 'Request cancelled.',
        ),
      _ => DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: 'Network error occurred. Please check your connection.',
        ),
    };

    handler.next(error);
  }
}
