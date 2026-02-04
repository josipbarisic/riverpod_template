sealed class NetworkResponse {
  NetworkResponse({int? httpStatusCode, String? message, this.data})
      : httpStatusCode = httpStatusCode ?? 400,
        message = message ?? 'Unknown status message';

  int httpStatusCode;
  String message;
  Object? data;
}

class NetworkErrorResponse extends NetworkResponse {
  NetworkErrorResponse({
    super.httpStatusCode,
    super.message,
    super.data,
  });
}

class NetworkSuccessResponse extends NetworkResponse {
  NetworkSuccessResponse({
    super.httpStatusCode = 200,
    super.message = 'Success',
    super.data,
  });
}
