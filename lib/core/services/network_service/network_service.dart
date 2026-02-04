import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_template/core/constants/network_constants.dart';
import 'package:riverpod_template/core/utils/network/error_interceptor.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';
import 'package:riverpod_template/flavors.dart';

class NetworkService {
  NetworkService({Dio? externalDio, Future<void> Function()? onUnauthorized}) {
    _dio = externalDio ?? Dio()
      ..options.connectTimeout = const Duration(seconds: 10)
      ..interceptors.addAll([
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => log(obj.toString(), name: 'DIO'),
        ),
        ErrorInterceptor(onUnauthorized: onUnauthorized),
      ]);
  }

  late Dio _dio;

  /// ------------------------- HTTP METHODS --------------------------
  /// GET
  Future<NetworkResponse> getHttp({
    String? baseURL,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      final Response<dynamic> response = await _dio.get(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        message: response.data?['message'] ?? response.statusMessage,
        data: response.data?['data'] ?? response.data,
        errorCode: response.data?['code'],
      );
    } on DioException catch (dioError) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.response?.data?['message'] ??
            dioError.response?.statusMessage ??
            dioError.message ??
            '',
        data: dioError.response?.data?['data'],
        errorCode: dioError.response?.data?['code'],
      );
    } catch (e) {
      return NetworkErrorResponse(httpStatusCode: 400, message: 'Error: $e');
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
    CancelToken? cancelToken,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.post(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          contentType: imageUpload ? httpFormDataType : httpContentTypeApplicationJson,
        ),
        data: body,
        cancelToken: cancelToken,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        message: response.data?['message'] ?? response.statusMessage,
        data: response.data?['data'],
        errorCode: response.data?['code'],
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.response?.data?['message'] ??
            dioError.response?.statusMessage ??
            dioError.message ??
            '',
        data: dioError.response?.data?['data'],
        errorCode: dioError.response?.data?['code'],
      );
    } catch (e) {
      return NetworkErrorResponse(httpStatusCode: 400, message: 'Error: $e');
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
    CancelToken? cancelToken,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.patch(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers, contentType: httpContentTypeApplicationJson),
        data: body,
        cancelToken: cancelToken,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        message: response.data?['message'] ?? response.statusMessage,
        data: response.data?['data'],
        errorCode: response.data?['code'],
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.response?.data?['message'] ??
            dioError.response?.statusMessage ??
            dioError.message ??
            '',
        data: dioError.response?.data?['data'],
        errorCode: dioError.response?.data?['code'],
      );
    } catch (e) {
      return NetworkErrorResponse(httpStatusCode: 400, message: 'Error: $e');
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
    CancelToken? cancelToken,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.delete(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers, contentType: httpContentTypeApplicationJson),
        data: body,
        cancelToken: cancelToken,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        message: response.data?['message'] ?? response.statusMessage,
        data: response.data?['data'],
        errorCode: response.data?['code'],
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.response?.data?['message'] ??
            dioError.response?.statusMessage ??
            dioError.message ??
            '',
        data: dioError.response?.data?['data'],
        errorCode: dioError.response?.data?['code'],
      );
    } catch (e) {
      return NetworkErrorResponse(httpStatusCode: 400, message: 'Error: $e');
    }
  }

  /// PUT
  Future<NetworkResponse> putHttp({
    String? baseURL,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic body,
    bool imageUpload = false,
    CancelToken? cancelToken,
  }) async {
    baseURL ??= FlavorConfig.baseURL;

    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.put(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers, contentType: httpContentTypeApplicationJson),
        data: body,
        cancelToken: cancelToken,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        message: response.data?['message'] ?? response.statusMessage,
        data: response.data?['data'],
        errorCode: response.data?['code'],
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.response?.data?['message'] ??
            dioError.response?.statusMessage ??
            dioError.message ??
            '',
        data: dioError.response?.data?['data'],
        errorCode: dioError.response?.data?['code'],
      );
    } catch (e) {
      return NetworkErrorResponse(httpStatusCode: 400, message: 'Error: $e');
    }
  }
}
