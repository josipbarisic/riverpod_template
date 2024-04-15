import 'package:dio/dio.dart';
import 'package:riverpod_template/data/network/network_response.dart';
import 'package:riverpod_template/flavors.dart';

class NetworkService {
  NetworkService({Dio? externalDio}) {
    _dio = externalDio ?? Dio()
      ..options.connectTimeout = const Duration(seconds: 10)
      // TODO(Me): Add custom interceptor
      ..interceptors.add(LogInterceptor());
  }

  late Dio _dio;

  /// ------------------------- HTTP METHODS --------------------------
  /// GET
  Future<NetworkResponse> getHttp({
    String? baseURL,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      final Response<dynamic> response = await _dio.get(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        data: response.data,
        message: response.statusMessage,
      );
    } on DioException catch (dioError) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.message,
        data: dioError.response?.data,
      );
    }
  }
}
