import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/data/network/network_response.dart';
import 'package:riverpod_template/services/network_service/network_service.dart';

class NetworkTestHelper {
  NetworkTestHelper(this.networkService);

  late NetworkService networkService;

  void arrangeGETRequest({
    required dynamic jsonResponse,
    String? endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    int statusCode = 200,
    bool isSuccess = true,
    // bool userLoggedIn = true,
  }) {
    // setLoggedIn(userLoggedIn);

    when(
      () => networkService.getHttp(
        endpoint: endpoint ?? any(named: 'endpoint'),
        queryParams: queryParams ?? any(named: 'queryParams'),
        headers: headers ?? any(named: 'headers'),
      ),
    ).thenAnswer(
      (_) async => isSuccess
          ? NetworkSuccessResponse(
              httpStatusCode: statusCode,
              message: 'HTTP Status: $statusCode',
              data: jsonResponse,
            )
          : NetworkErrorResponse(
              httpStatusCode: statusCode,
              message: 'HTTP Status: $statusCode',
              data: jsonResponse,
            ),
    );
  }

  void arrangePOSTRequest({
    required dynamic jsonResponse,
    String? endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    int statusCode = 200,
    bool isSuccess = true,
    // bool userLoggedIn = true,
  }) {
    // setLoggedIn(userLoggedIn);

    when(
      () => networkService.postHttp(
        endpoint: endpoint ?? any(named: 'endpoint'),
        queryParams: queryParams ?? any(named: 'queryParams'),
        headers: headers ?? any(named: 'headers'),
        body: headers ?? any(named: 'body'),
      ),
    ).thenAnswer(
      (_) async => isSuccess
          ? NetworkSuccessResponse(
              httpStatusCode: statusCode,
              message: 'HTTP Status: $statusCode',
              data: jsonResponse,
            )
          : NetworkErrorResponse(
              httpStatusCode: statusCode,
              message: 'HTTP Status: $statusCode',
              data: jsonResponse,
            ),
    );
  }
}
