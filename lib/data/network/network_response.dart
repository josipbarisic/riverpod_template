sealed class NetworkResponse {
  NetworkResponse({int? httpStatusCode, String? message, this.data
      // Status code -1 would signify that none of the response data was available. Unit test the
      // NetworkService methods to verify these cases.
      })
      : httpStatusCode = httpStatusCode ?? -1,
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
    super.httpStatusCode,
    super.message,
    super.data,
  });
}
