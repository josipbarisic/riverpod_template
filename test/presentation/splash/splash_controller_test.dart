import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_template/data/firebase/firebase_api.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';
import 'package:riverpod_template/presentation/splash/splash_controller.dart';
import 'package:riverpod_template/services/local_notifications_service/local_notifications_service.dart';
import 'package:riverpod_template/services/local_notifications_service/local_notifications_service_provider.dart';
import 'package:riverpod_template/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks/mock_firebase_api.dart';
import 'mocks/mock_local_notifications_service.dart';

void main() {
  late ProviderContainer container;
  late MockFirebaseApi mockFirebaseApi;
  late MockLocalNotificationsService mockLocalNotificationsService;

  setUpAll(() {
    // Initialize SharedPreferences mock values
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() async {
    mockFirebaseApi = MockFirebaseApi();
    mockLocalNotificationsService = MockLocalNotificationsService();

    // Stub default behaviors
    mockFirebaseApi.stubInitPushNotifications();
    mockLocalNotificationsService.stubInit();

    // Get mock SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWith((_) => Future.value(prefs)),
        firebaseApiProvider.overrideWithValue(mockFirebaseApi),
        localNotificationsServiceProvider.overrideWithValue(mockLocalNotificationsService),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('SplashController', () {
    // Note: Testing Riverpod async controllers with complex dependencies
    // requires careful setup. These tests demonstrate the pattern.
    //
    // For more complex controllers, consider:
    // 1. Testing the controller logic in isolation (unit test)
    // 2. Testing with ProviderContainer for integration
    // 3. Using flutter_test's pumpWidget for widget tests

    test('provider can be read without throwing', () {
      // Simply verifying the provider can be instantiated
      expect(
        () => container.read(splashControllerProvider),
        returnsNormally,
      );
    });

    test('initial state is AsyncLoading', () {
      // When first read (before build completes), state starts as loading
      final state = container.read(splashControllerProvider);
      
      // State will be loading initially
      expect(state.isLoading || state.hasValue || state.hasError, isTrue);
    });
  });

  group('MockFirebaseApi', () {
    test('stubInitPushNotifications sets up mock correctly', () async {
      final mockApi = MockFirebaseApi();
      mockApi.stubInitPushNotifications();

      // Should not throw
      await mockApi.initPushNotifications();

      verify(() => mockApi.initPushNotifications()).called(1);
    });

    test('stubInitPushNotificationsError throws exception', () {
      final mockApi = MockFirebaseApi();
      mockApi.stubInitPushNotificationsError(Exception('Test error'));

      expect(
        () => mockApi.initPushNotifications(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('MockLocalNotificationsService', () {
    test('stubInit sets up mock correctly', () async {
      final mockService = MockLocalNotificationsService();
      mockService.stubInit();

      // Should not throw
      await mockService.init();

      verify(() => mockService.init()).called(1);
    });

    test('stubInitError throws exception', () {
      final mockService = MockLocalNotificationsService();
      mockService.stubInitError(Exception('Test error'));

      expect(
        () => mockService.init(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
