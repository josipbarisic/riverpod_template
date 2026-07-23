import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/core/services/network_service/network_service.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';

/// Mock implementation of [NetworkService] for testing.
///
/// Provides stub methods for common HTTP operations.
class MockNetworkService extends Mock implements NetworkService {
  /// Stub a successful GET request
  void stubGetSuccess(dynamic data, {int statusCode = 200}) {
    when(() => getHttp(
          endpoint: any(named: 'endpoint'),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
          cancelToken: any(named: 'cancelToken'),
          baseURL: any(named: 'baseURL'),
        )).thenAnswer((_) async => NetworkSuccessResponse(
          httpStatusCode: statusCode,
          data: data,
          message: 'Success',
        ));
  }

  /// Stub a GET request for a specific endpoint
  void stubGetForEndpoint(String endpoint, dynamic data, {int statusCode = 200}) {
    when(() => getHttp(
          endpoint: endpoint,
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
          cancelToken: any(named: 'cancelToken'),
          baseURL: any(named: 'baseURL'),
        )).thenAnswer((_) async => NetworkSuccessResponse(
          httpStatusCode: statusCode,
          data: data,
          message: 'Success',
        ));
  }

  /// Stub a failed GET request
  void stubGetError({
    String message = 'Request failed',
    int statusCode = 500,
    dynamic data,
  }) {
    when(() => getHttp(
          endpoint: any(named: 'endpoint'),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
          cancelToken: any(named: 'cancelToken'),
          baseURL: any(named: 'baseURL'),
        )).thenAnswer((_) async => NetworkErrorResponse(
          httpStatusCode: statusCode,
          message: message,
          data: data,
        ));
  }

  /// Stub a successful POST request
  void stubPostSuccess(dynamic data, {int statusCode = 200}) {
    when(() => postHttp(
          endpoint: any(named: 'endpoint'),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          cancelToken: any(named: 'cancelToken'),
          baseURL: any(named: 'baseURL'),
          imageUpload: any(named: 'imageUpload'),
        )).thenAnswer((_) async => NetworkSuccessResponse(
          httpStatusCode: statusCode,
          data: data,
          message: 'Success',
        ));
  }

  /// Stub a failed POST request
  void stubPostError({
    String message = 'Request failed',
    int statusCode = 500,
    dynamic data,
  }) {
    when(() => postHttp(
          endpoint: any(named: 'endpoint'),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          cancelToken: any(named: 'cancelToken'),
          baseURL: any(named: 'baseURL'),
          imageUpload: any(named: 'imageUpload'),
        )).thenAnswer((_) async => NetworkErrorResponse(
          httpStatusCode: statusCode,
          message: message,
          data: data,
        ));
  }

  /// Stub a successful PATCH request
  void stubPatchSuccess(dynamic data, {int statusCode = 200}) {
    when(() => patchHttp(
          endpoint: any(named: 'endpoint'),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          cancelToken: any(named: 'cancelToken'),
          baseURL: any(named: 'baseURL'),
          imageUpload: any(named: 'imageUpload'),
        )).thenAnswer((_) async => NetworkSuccessResponse(
          httpStatusCode: statusCode,
          data: data,
          message: 'Success',
        ));
  }

  /// Stub a successful DELETE request
  void stubDeleteSuccess({int statusCode = 200}) {
    when(() => deleteHttp(
          endpoint: any(named: 'endpoint'),
          queryParams: any(named: 'queryParams'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          cancelToken: any(named: 'cancelToken'),
          baseURL: any(named: 'baseURL'),
          imageUpload: any(named: 'imageUpload'),
        )).thenAnswer((_) async => NetworkSuccessResponse(
          httpStatusCode: statusCode,
          message: 'Deleted',
        ));
  }
}
