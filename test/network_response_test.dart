import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/data/network/network_response.dart';

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
      );
      assert(sut.httpStatusCode == 400);
      assert(sut.message == 'Unknown status message');
      assert(sut.data == null);
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
  });

  group('NetworkErrorResponse', () {
    test('Default values replace null arguments', () {
      sut = NetworkErrorResponse(
        httpStatusCode: null,
        message: null,
        data: null,
      );
      assert(sut.httpStatusCode == 400);
      assert(sut.message == 'Unknown status message');
      assert(sut.data == null);
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
  });
}
