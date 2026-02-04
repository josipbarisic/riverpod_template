import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';

import 'test_data/network_service_test_data.dart';

void main() {
  /// SUT - Subject Under Test
  late NetworkResponse sut;

  setUp(() async {});
  tearDown(() {});

  group('NetworkSuccessResponse', () {
    test('Default values replace null arguments', () {
      sut = NetworkSuccessResponse(
        httpStatusCode: null,
        message: null,
        data: null,
        errorCode: null,
      );
      assert(sut.httpStatusCode == 400);
      assert(sut.message == 'Request failed');
      assert(sut.data == null);
      assert(sut.errorCode == null);
    });

    test('Success response data', () {
      sut = NetworkSuccessResponse(
        httpStatusCode: successResponse.statusCode,
        message: successResponse.statusMessage,
        data: successResponse.data,
      );
      assert(sut.httpStatusCode == 200);
      assert(sut.message == 'Success');
      assert(sut.data is Map);
    });

    test('Success response with errorCode', () {
      sut = NetworkSuccessResponse(
        httpStatusCode: 200,
        message: 'Success',
        data: {'key': 'value'},
        errorCode: 0,
      );
      assert(sut.httpStatusCode == 200);
      assert(sut.message == 'Success');
      assert(sut.errorCode == 0);
    });
  });

  group('NetworkErrorResponse', () {
    test('Default values replace null arguments', () {
      sut = NetworkErrorResponse(
        httpStatusCode: null,
        message: null,
        data: null,
        errorCode: null,
      );
      assert(sut.httpStatusCode == 400);
      assert(sut.message == 'Request failed');
      assert(sut.data == null);
      assert(sut.errorCode == null);
    });

    test('Error response data', () {
      sut = NetworkErrorResponse(
        httpStatusCode: errorResponse.statusCode,
        message: errorResponse.statusMessage,
        data: errorResponse.data,
      );
      assert(sut.httpStatusCode == 404);
      assert(sut.message == 'Error');
      assert(sut.data == null);
    });

    test('Error response with backend errorCode', () {
      sut = NetworkErrorResponse(
        httpStatusCode: 400,
        message: 'Validation failed',
        data: {'errors': ['Invalid email']},
        errorCode: 1001,
      );
      assert(sut.httpStatusCode == 400);
      assert(sut.message == 'Validation failed');
      assert(sut.errorCode == 1001);
    });
  });
}
