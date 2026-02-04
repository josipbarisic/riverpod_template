import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/data/repositories/user_repository/user_repository.dart';
import 'package:riverpod_template/models/user/user.dart';
import 'package:riverpod_template/core/utils/network/endpoints.dart';

import '../helpers/mock_network_service.dart';
import '../test_data/auth_test_data.dart';

void main() {
  late UserRepository repository;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockNetworkService = MockNetworkService();
    repository = UserRepository(networkService: mockNetworkService);
  });

  group('UserRepository', () {
    group('fetchUserData', () {
      test('returns user when API call is successful', () async {
        // Arrange
        const userId = 123;
        final expectedUser = TestUsers.complete;
        final userJson = expectedUser.toJson();

        mockNetworkService.stubGetForEndpoint(Endpoints.user(userId), userJson);

        // Act
        final result = await repository.fetchUserData(userId);

        // Assert
        expect(result.id, equals(expectedUser.id));
        expect(result.email, equals(expectedUser.email));
        expect(result.firstName, equals(expectedUser.firstName));
        expect(result.lastName, equals(expectedUser.lastName));

        verify(() => mockNetworkService.getHttp(
              endpoint: Endpoints.user(userId),
              queryParams: any(named: 'queryParams'),
              headers: any(named: 'headers'),
              cancelToken: any(named: 'cancelToken'),
              baseURL: any(named: 'baseURL'),
            )).called(1);
      });

      test('throws exception when JSON parsing fails', () async {
        // Arrange
        const userId = 123;
        final invalidJson = {'invalid': 'data'}; // Missing required fields

        mockNetworkService.stubGetForEndpoint(Endpoints.user(userId), invalidJson);

        // Act & Assert
        expect(
          () => repository.fetchUserData(userId),
          throwsA(isA<TypeError>()),
        );
      });

      test('uses correct endpoint with user ID', () async {
        // Arrange
        const userId = 456;
        final userJson = TestUsers.basic.toJson();

        mockNetworkService.stubGetForEndpoint(Endpoints.user(userId), userJson);

        // Act
        await repository.fetchUserData(userId);

        // Assert
        verify(() => mockNetworkService.getHttp(
              endpoint: Endpoints.user(userId),
              queryParams: any(named: 'queryParams'),
              headers: any(named: 'headers'),
              cancelToken: any(named: 'cancelToken'),
              baseURL: any(named: 'baseURL'),
            )).called(1);
      });
    });

    group('fetchSomeUsers', () {
      test('returns list of users when API call is successful', () async {
        // Arrange
        final usersJson = TestUsers.list(3).map((u) => u.toJson()).toList();

        mockNetworkService.stubGetForEndpoint(Endpoints.users, usersJson);

        // Act
        final result = await repository.fetchSomeUsers();

        // Assert
        expect(result, isA<List<User>>());
        expect(result, hasLength(3));
      });

      test('returns empty list when API returns empty array', () async {
        // Arrange
        mockNetworkService.stubGetForEndpoint(Endpoints.users, <Map<String, dynamic>>[]);

        // Act
        final result = await repository.fetchSomeUsers();

        // Assert
        expect(result, isEmpty);
      });

      test('returns empty list when JSON parsing fails', () async {
        // Arrange
        final invalidJson = [
          {'invalid': 'data'},
          {'also': 'invalid'},
        ];

        mockNetworkService.stubGetForEndpoint(Endpoints.users, invalidJson);

        // Act
        final result = await repository.fetchSomeUsers();

        // Assert
        // Repository catches parsing errors and returns empty list
        expect(result, isEmpty);
      });

      test('calls correct endpoint', () async {
        // Arrange
        mockNetworkService.stubGetForEndpoint(Endpoints.users, <Map<String, dynamic>>[]);

        // Act
        await repository.fetchSomeUsers();

        // Assert
        verify(() => mockNetworkService.getHttp(
              endpoint: Endpoints.users,
              queryParams: any(named: 'queryParams'),
              headers: any(named: 'headers'),
              cancelToken: any(named: 'cancelToken'),
              baseURL: any(named: 'baseURL'),
            )).called(1);
      });
    });

    group('updateUserData', () {
      test('throws UnimplementedError', () async {
        // Arrange
        final user = TestUsers.basic;

        // Act & Assert
        expect(
          () => repository.updateUserData(user),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
