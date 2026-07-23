import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_template/core/enums/sign_in_provider_enum.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository_providers.dart';
import 'package:riverpod_template/presentation/login/login_controller.dart';
import 'package:riverpod_template/presentation/login/login_state.dart';

import '../../test_data/auth_test_data.dart';

/// Mock of the concrete AuthRepository class for provider override.
class MockConcreteAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockConcreteAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockConcreteAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('LoginController', () {
    test('initial state builds without error', () async {
      final state = container.read(loginControllerProvider);
      expect(state.isLoading || state.hasValue, isTrue);
    });

    test('reset() returns state to initial LoginState', () async {
      final notifier = container.read(loginControllerProvider.notifier);
      await container.read(loginControllerProvider.future);

      notifier.reset();

      final state = container.read(loginControllerProvider);
      expect(state.value, equals(const LoginState()));
    });

    group('onSubmit', () {
      test('Google sign-in success sets isAuthSuccess', () async {
        final user = TestUsers.basic;
        when(() => mockAuthRepo.continueWithGoogle())
            .thenAnswer((_) async => NetworkSuccessResponse(data: user));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        await notifier.onSubmit(provider: SignInProvider.google);

        final state = container.read(loginControllerProvider);
        expect(state.value?.isAuthSuccess, isTrue);
      });

      test('Google sign-in error sets AsyncError', () async {
        when(() => mockAuthRepo.continueWithGoogle())
            .thenAnswer((_) async => NetworkErrorResponse(
                  httpStatusCode: 401,
                  message: 'Google sign-in failed',
                ));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        await notifier.onSubmit(provider: SignInProvider.google);

        final state = container.read(loginControllerProvider);
        expect(state.hasError, isTrue);
      });

      test('Apple sign-in success sets isAuthSuccess', () async {
        final user = TestUsers.basic;
        when(() => mockAuthRepo.continueWithApple())
            .thenAnswer((_) async => NetworkSuccessResponse(data: user));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        await notifier.onSubmit(provider: SignInProvider.apple);

        final state = container.read(loginControllerProvider);
        expect(state.value?.isAuthSuccess, isTrue);
      });

      test('Apple sign-in error sets AsyncError', () async {
        when(() => mockAuthRepo.continueWithApple())
            .thenAnswer((_) async => NetworkErrorResponse(
                  httpStatusCode: 401,
                  message: 'Apple sign-in cancelled',
                ));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        await notifier.onSubmit(provider: SignInProvider.apple);

        final state = container.read(loginControllerProvider);
        expect(state.hasError, isTrue);
      });

      test('email sign-in success sets isAuthSuccess', () async {
        final user = TestUsers.basic;
        when(() => mockAuthRepo.signInWithEmailAndPassword(any(), any()))
            .thenAnswer((_) async => NetworkSuccessResponse(data: user));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        await notifier.onSubmit(
          provider: SignInProvider.email,
          email: 'test@example.com',
          password: 'Password1',
        );

        final state = container.read(loginControllerProvider);
        expect(state.value?.isAuthSuccess, isTrue);
      });

      test('email sign-in error sets AsyncError with message', () async {
        when(() => mockAuthRepo.signInWithEmailAndPassword(any(), any()))
            .thenAnswer((_) async => NetworkErrorResponse(
                  httpStatusCode: 401,
                  message: 'Invalid credentials',
                ));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        await notifier.onSubmit(
          provider: SignInProvider.email,
          email: 'test@example.com',
          password: 'wrong',
        );

        final state = container.read(loginControllerProvider);
        expect(state.hasError, isTrue);
      });

      test('phone sign-in success returns verificationId', () async {
        when(() => mockAuthRepo.initPhoneNumberVerification(any()))
            .thenAnswer((_) async => NetworkSuccessResponse(data: 'verify-123'));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        final verificationId =
            await notifier.continueWithPhoneNumber(phoneNumber: '+1234567890');

        expect(verificationId, equals('verify-123'));
      });

      test('phone sign-in error returns null and sets error', () async {
        when(() => mockAuthRepo.initPhoneNumberVerification(any()))
            .thenAnswer((_) async => NetworkErrorResponse(
                  httpStatusCode: 400,
                  message: 'Invalid phone number',
                ));

        final notifier = container.read(loginControllerProvider.notifier);
        await container.read(loginControllerProvider.future);

        final verificationId =
            await notifier.continueWithPhoneNumber(phoneNumber: '+invalid');

        expect(verificationId, isNull);
        final state = container.read(loginControllerProvider);
        expect(state.hasError, isTrue);
      });
    });
  });

  group('LoginState', () {
    test('default state has correct values', () {
      const state = LoginState();
      expect(state.selectedProvider, isNull);
      expect(state.registrationStep, isNull);
      expect(state.isAuthSuccess, isFalse);
    });

    test('equality works correctly', () {
      const state1 = LoginState(isAuthSuccess: true);
      const state2 = LoginState(isAuthSuccess: true);
      const state3 = LoginState(isAuthSuccess: false);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('copyWith creates correct copy', () {
      const original = LoginState();
      final copied = original.copyWith(isAuthSuccess: true);

      expect(copied.isAuthSuccess, isTrue);
      expect(copied.selectedProvider, isNull);
    });

    test('copyWith preserves unmodified fields', () {
      const original = LoginState(
        selectedProvider: SignInProvider.google,
        isAuthSuccess: false,
      );
      final copied = original.copyWith(isAuthSuccess: true);

      expect(copied.selectedProvider, equals(SignInProvider.google));
      expect(copied.isAuthSuccess, isTrue);
    });
  });
}
