sealed class NetworkResponse {
  NetworkResponse({int? httpStatusCode, String? message, this.data, this.errorCode})
      : httpStatusCode = httpStatusCode ?? 400,
        message = message ?? 'Request failed';

  int httpStatusCode;
  String message;
  Object? data;
  
  /// Backend-specific error code (separate from HTTP status code).
  int? errorCode;
}

class NetworkErrorResponse extends NetworkResponse {
  NetworkErrorResponse({
    super.httpStatusCode,
    super.message,
    super.data,
    super.errorCode,
  });
}

class NetworkSuccessResponse extends NetworkResponse {
  NetworkSuccessResponse({
    super.httpStatusCode = 200,
    super.message = 'Success',
    super.data,
    super.errorCode,
  });
}
