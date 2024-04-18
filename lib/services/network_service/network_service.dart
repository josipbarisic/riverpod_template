import 'package:dio/dio.dart';
import 'package:riverpod_template/flavors.dart';
import 'package:riverpod_template/utils/constants/network_constants.dart';
import 'package:riverpod_template/utils/network/network_response.dart';

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

  /// POST
  Future<NetworkResponse> postHttp({
    String? baseURL,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic body,
    bool imageUpload = false,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.post(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          contentType: imageUpload ? HTTP_FORM_DATA_TYPE : HTTP_CONTENT_TYPE_APP_JSON,
        ),
        data: body,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        data: response.data,
        message: response.statusMessage,
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.message ?? '',
        data: dioError.response?.data,
      );
    } catch (e) {
      return NetworkErrorResponse(
        httpStatusCode: 400,
        message: 'Error: $e',
      );
    }
  }

  /// PATCH
  Future<NetworkResponse> patchHttp({
    String? baseURL,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic body,
    bool imageUpload = false,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.patch(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          contentType: HTTP_CONTENT_TYPE_APP_JSON,
        ),
        data: body,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        data: response.data,
        message: response.statusMessage,
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.message ?? '',
        data: dioError.response?.data,
      );
    } catch (e) {
      return NetworkErrorResponse(
        httpStatusCode: 400,
        message: 'Error: $e',
      );
    }
  }

  /// DELETE
  Future<NetworkResponse> deleteHttp({
    String? baseURL,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic body,
    bool imageUpload = false,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.delete(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          contentType: HTTP_CONTENT_TYPE_APP_JSON,
        ),
        data: body,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        data: response.data,
        message: response.statusMessage,
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.message ?? '',
        data: dioError.response?.data,
      );
    } catch (e) {
      return NetworkErrorResponse(
        httpStatusCode: 400,
        message: 'Error: $e',
      );
    }
  }
}
