import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:riverpod_template/data/network/network_response.dart';
import 'package:riverpod_template/services/network_service.dart';

import '../test_data/network_service_test_data.dart';

void main() {
  /// SUT - Subject Under Test
  late NetworkService sut;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() async {
    dio = Dio()..interceptors.removeWhere((_) => true);
    sut = NetworkService(externalDio: dio);
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
  });

  tearDown(() {
    dioAdapter.close(force: true);
    dio.close(force: true);
  });

  group('NetworkService - GET', () {
    test('Is NetworkErrorResponse on DioException', () async {
      dioAdapter.onGet(
        mockBaseURL,
        (server) => server.throws(404, dio404Exception),
      );

      final response = await sut.getHttp(baseURL: mockBaseURL, endpoint: '');

      expect(response, isA<NetworkErrorResponse>());
    });

    test('Is NetworkSuccessResponse on Success', () async {
      dioAdapter.onGet(
        mockBaseURL,
        (server) => server.reply(200, successResponse.data),
      );

      final response = await sut.getHttp(baseURL: mockBaseURL, endpoint: '');

      expect(response, isA<NetworkSuccessResponse>());
    });
  });
}
