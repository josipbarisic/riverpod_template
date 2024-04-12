import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_template/data/network/network_response.dart';

void main() {
  /// SUT - Subject Under Test
  late NetworkResponse sut;

  setUp(() async {});
  tearDown(() {});

  group('NetworkSuccessResponse - ', () {
    test('Default values replace null arguments', () async {
      sut = NetworkSuccessResponse(
        httpStatusCode: null,
        message: null,
        data: null,
      );
      assert(sut.httpStatusCode == -1);
      assert(sut.message == 'Unknown status message');
      assert(sut.data == null);
    });
  });

  group('NetworkErrorResponse - ', () {
    test('Default values replace null arguments', () async {
      sut = NetworkErrorResponse(
        httpStatusCode: null,
        message: null,
        data: null,
      );
      assert(sut.httpStatusCode == -1);
      assert(sut.message == 'Unknown status message');
      assert(sut.data == null);
    });
  });
}
