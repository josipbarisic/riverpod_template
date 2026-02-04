# Testing Strategy

This document defines the testing philosophy, structure, and best practices for projects built from this template.

---

## Philosophy

1. **Tests are mandatory** – No code ships without tests for critical paths
2. **Test behavior, not implementation** – Focus on what code does, not how
3. **Fast feedback loop** – Unit tests run in milliseconds, not seconds
4. **Isolated by default** – Each test is independent, mocks all dependencies

---

## Testing Pyramid

```
        ┌───────────────┐
        │  Integration  │  Few, slow, high confidence
        └───────────────┘
       ┌─────────────────┐
       │   Widget Tests  │  Some, moderate speed
       └─────────────────┘
      ┌───────────────────┐
      │    Unit Tests     │  Many, fast, focused
      └───────────────────┘
```

- **Unit Tests (70%)**: Controllers, repositories, services, models
- **Widget Tests (20%)**: UI components, user interactions
- **Integration Tests (10%)**: Critical user flows end-to-end

---

## Test Organization

```
test/
├── presentation/           # Feature tests (mirrors lib/presentation/)
│   ├── login/
│   │   ├── login_controller_test.dart
│   │   ├── login_view_test.dart
│   │   └── mocks/
│   │       └── mock_auth_repository.dart
│   ├── home/
│   │   └── home_controller_test.dart
│   └── ...
├── repositories/           # Repository unit tests
│   └── auth_repository_test.dart
├── domain/                 # Model/domain tests
│   └── user_test.dart
├── services/               # Service tests
│   └── network_service_test.dart
├── test_data/              # Shared test data factories
│   ├── auth_test_data.dart
│   └── user_test_data.dart
└── helpers/                # Test utilities
    └── test_helpers.dart
```

### Naming Convention

- Test files: `{name}_test.dart`
- Mock files: `mock_{name}.dart`
- Test data files: `{feature}_test_data.dart`

---

## Unit Testing Strategy

### What to Unit Test

| Component | What to Test |
|-----------|--------------|
| **Controllers** | State transitions, method behavior, error handling |
| **Repositories** | API calls (with mocked network), data transformation |
| **Services** | Business logic, edge cases |
| **Models** | Serialization, computed properties, equality |

### Controller Testing

Controllers are tested using `ProviderContainer` with overridden dependencies:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_template/presentation/login/login_controller.dart';

import 'mocks/mock_auth_repository.dart';
import '../../test_data/auth_test_data.dart';

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('LoginController', () {
    test('initial state is correct', () {
      final state = container.read(loginControllerProvider);
      expect(state.hasValue, isTrue);
      expect(state.value?.isLoading, isFalse);
    });

    test('login success updates state with user', () async {
      final testUser = TestUsers.basic;
      mockAuthRepository.stubLoginSuccess(testUser);

      final controller = container.read(loginControllerProvider.notifier);
      await controller.login('test@example.com', 'password123');

      final state = container.read(loginControllerProvider);
      expect(state.value?.user, equals(testUser));
      expect(state.value?.error, isNull);
    });

    test('login failure updates state with error', () async {
      mockAuthRepository.stubLoginError(Exception('Invalid credentials'));

      final controller = container.read(loginControllerProvider.notifier);
      await controller.login('test@example.com', 'wrong-password');

      final state = container.read(loginControllerProvider);
      expect(state.value?.error, isNotNull);
    });
  });
}
```

### Repository Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';

import '../helpers/mock_network_service.dart';

void main() {
  late AuthRepository repository;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockNetworkService = MockNetworkService();
    repository = AuthRepository(networkService: mockNetworkService);
  });

  group('AuthRepository', () {
    test('login returns user on success', () async {
      mockNetworkService.stubPostSuccess({
        'id': '123',
        'email': 'test@example.com',
        'name': 'Test User',
      });

      final user = await repository.login('test@example.com', 'password');

      expect(user.id, equals('123'));
      expect(user.email, equals('test@example.com'));
    });
  });
}
```

---

## Mocking Strategy

### Use mocktail

All mocks use the `mocktail` package for type-safe mocking:

```dart
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
```

### Stub Pattern

Mocks expose stub methods for common scenarios:

```dart
class MockAuthRepository extends Mock implements AuthRepository {
  /// Stub successful login
  void stubLoginSuccess(User user) {
    when(() => login(any(), any())).thenAnswer((_) async => user);
  }

  /// Stub login failure
  void stubLoginError(Exception error) {
    when(() => login(any(), any())).thenThrow(error);
  }

  /// Stub getCurrentUser
  void stubGetCurrentUser(User? user) {
    when(() => getCurrentUser()).thenAnswer((_) async => user);
  }
}
```

### What to Mock

| Mock | Don't Mock |
|------|------------|
| Repositories | Controllers |
| Network services | State classes |
| External SDKs (Firebase, etc.) | Pure functions |
| Platform services | Domain models |

---

## Test Data Patterns

### Factory Functions

Create flexible test data with factory functions:

```dart
// test/test_data/auth_test_data.dart
import 'package:riverpod_template/domain/user.dart';

/// Create a test user with optional overrides
User createTestUser({
  String? id,
  String? email,
  String? name,
  DateTime? createdAt,
}) => User(
  id: id ?? 'test-user-id',
  email: email ?? 'test@example.com',
  name: name ?? 'Test User',
  createdAt: createdAt ?? DateTime(2024, 1, 1),
);

/// Pre-built test user constants
class TestUsers {
  static User get basic => createTestUser();
  
  static User get admin => createTestUser(
    id: 'admin-id',
    email: 'admin@example.com',
    name: 'Admin User',
  );

  static List<User> list(int count) => List.generate(
    count,
    (i) => createTestUser(id: 'user-$i', name: 'User $i'),
  );
}
```

### When to Use Factories vs Constants

- **Factories**: When tests need unique or customized data
- **Constants**: When tests need consistent, reusable data

---

## Widget Testing

### Basic Widget Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_template/presentation/login/login_view.dart';

import 'mocks/mock_auth_repository.dart';

void main() {
  testWidgets('LoginView shows email and password fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MaterialApp(
          home: LoginView(),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Login button triggers login', (tester) async {
    final mockRepo = MockAuthRepository();
    mockRepo.stubLoginSuccess(TestUsers.basic);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: const MaterialApp(
          home: LoginView(),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('email-field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password-field')), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verify(() => mockRepo.login('test@example.com', 'password')).called(1);
  });
}
```

---

## Best Practices

### Do

- Write tests alongside code (not after)
- Test one thing per test
- Use descriptive test names that explain behavior
- Keep tests fast (< 100ms per unit test)
- Use `group()` to organize related tests
- Clean up resources in `tearDown()`

### Don't

- Test private implementation details
- Write tests that depend on other tests
- Use real network calls or databases
- Test framework code (Flutter, Riverpod)
- Over-mock – if everything is mocked, you're testing nothing

### Test Naming

```dart
// Good: Describes behavior
test('login with valid credentials updates state to authenticated', () {});
test('login with invalid password shows error message', () {});

// Bad: Describes implementation
test('calls repository login method', () {});
test('sets isLoading to true', () {});
```

---

## Running Tests

### All Tests

```bash
flutter test
```

### Specific Feature

```bash
flutter test test/presentation/login/
```

### With Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Watch Mode (requires `very_good_cli`)

```bash
very_good test --watch
```

---

## Pre-Commit Checklist

Before every commit:

- [ ] Run `flutter test` – all tests pass
- [ ] New code has corresponding tests
- [ ] No skipped tests without TODO comment
- [ ] Test data is in `test/test_data/`, not hardcoded

---

## CI Integration

Tests run automatically on every PR. The CI pipeline:

1. Runs `flutter analyze`
2. Runs `flutter test`
3. Reports coverage

PRs with failing tests cannot be merged.
