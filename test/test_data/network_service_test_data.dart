import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_template/utils/constants/network_constants.dart';

const String mockBaseURL = 'https://riverpod_template_test.com';

final RequestOptions requestOptions = RequestOptions(
  path: mockBaseURL,
  headers: mockHeaders,
);

final Map<String, dynamic> mockHeaders = {
  HttpHeaders.contentTypeHeader: httpContentTypeApplicationJson,
  HttpHeaders.contentLengthHeader: 2,
};

/// ======================== Exceptions =========================
final DioException dio404Exception = DioException(
  error: <String, dynamic>{'message': 'Not found'},
  requestOptions: requestOptions,
  response: Response<dynamic>(
    statusCode: 404,
    requestOptions: requestOptions,
    statusMessage: 'Not found',
  ),
  message: 'Not found',
  type: DioExceptionType.badResponse,
);

/// ======================== Responses =========================
final Response successResponse = Response(
  statusCode: 200,
  statusMessage: 'Success',
  data: {'email': 'test@email.com', 'username': 'test_user'},
  requestOptions: RequestOptions(),
);

final Response errorResponse = Response(
  statusCode: 404,
  statusMessage: 'Error',
  data: null,
  requestOptions: RequestOptions(),
);
