---
description: Create tests for features, files, methods, or widgets (unit, widget, or integration)
---

## Create Tests

### Step 1: Determine What to Test

**Ask user:**

- What do you want to test?
    - **Feature** (e.g., `login`)
    - **File** (e.g., `login_controller.dart`)
    - **Method** (e.g., `LoginController.onSubmit()`)
    - **Widget** (e.g., `LoginView`)
    - **Repository** (e.g., `AuthRepository.signInWithEmailAndPassword()`)
    - **Other** (specify)

### Step 2: Determine Test Type

**Ask user:**

- What type of test?
    - **Unit test** - Test individual functions/methods in isolation
    - **Widget test** - Test widget rendering and interaction
    - **Integration test** - Test full flows/features end-to-end

**Guidelines:**

- **Unit test**: For controllers, repositories, utilities, business logic
- **Widget test**: For views, widgets, UI components
- **Integration test**: For complete user flows, API integration

### Step 3: STEP 0 - Mandatory Reads

1. Read `ARCHITECTURE.md` (testing patterns, structure)
2. Read `lib/AGENTS.md` (test infrastructure section)
3. Read `docs/TESTING_STRATEGY.md` (philosophy, patterns, examples)
4. If testing a feature: Read manifest `lib/manifests/{feature}.manifest.generated.json`
5. If testing a file: Read the actual file to understand structure
6. Check existing tests: `test/presentation/{feature}/`

**Extract:**

- Code structure to test
- Dependencies to mock
- Existing test patterns
- Test utilities available

### Step 4: STATE What You Read

```markdown
**FILES READ**:
- `ARCHITECTURE.md`
- `lib/AGENTS.md`
- `docs/TESTING_STRATEGY.md`
- `lib/manifests/{feature}.manifest.generated.json` (if feature)
- `lib/presentation/{feature}/{file}.dart` (if specific file)
- `test/presentation/{feature}/{existing_test}.dart` (if exists)

**TO TEST**:
- Target: {what to test}
- Type: {unit/widget/integration}
- Location: {file path}
```

### Step 5: Determine Test Location

**Based on what to test:**

**Unit Tests:**

- Controllers: `test/presentation/{feature}/{feature}_controller_test.dart`
- Repositories: `test/repositories/{repo}_repository_test.dart`
- Services: `test/services/{service}_test.dart`
- Models: `test/domain/{model}_test.dart`

**Widget Tests:**

- Views: `test/presentation/{feature}/{feature}_view_test.dart`
- Widgets: `test/presentation/{feature}/widgets/{widget}_test.dart`
- Shared widgets: `test/presentation/widgets/{widget}_test.dart`

**Integration Tests:**

- Flows: `integration_test/{feature}_flow_test.dart`
- Features: `integration_test/{feature}_integration_test.dart`

### Step 6: Analyze Dependencies

**From code analysis, identify:**

- **Dependencies to mock:**
    - Repositories
    - Services
    - Providers
    - External APIs

- **Test data needed:**
    - Models/entities
    - Mock responses
    - Test fixtures

**Check existing mocks:**

- `test/presentation/{feature}/mocks/`
- `test/helpers/`

### Step 7: Create Test Structure

#### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../../test_data/{feature}_test_data.dart';
import 'mocks/mock_{dependency}_repository.dart';

void main() {
  late ProviderContainer container;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('{ClassName} Tests', () {
    test('should {expected_behavior} when {condition}', () async {
      // Arrange
      mockRepository.stubMethod(TestData.value);

      // Act
      final controller = container.read(controllerProvider.notifier);
      await controller.method();

      // Assert
      final state = container.read(controllerProvider);
      expect(state.value?.field, equals(expected));
    });
  });
}
```

#### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_template/presentation/{feature}/{feature}_view.dart';

import 'mocks/mock_{dependency}_repository.dart';

void main() {
  group('{WidgetName} Widget Tests', () {
    testWidgets('should {expected_behavior} when {condition}', (tester) async {
      // Build widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            repositoryProvider.overrideWithValue(MockRepository()),
          ],
          child: const MaterialApp(
            home: {WidgetName}(),
          ),
        ),
      );

      // Find widgets
      final button = find.text('Button Text');
      final textField = find.byType(TextField);

      // Verify initial state
      expect(button, findsOneWidget);
      expect(textField, findsOneWidget);

      // Interact
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verify result
      expect(find.text('Expected Result'), findsOneWidget);
    });
  });
}
```

#### Integration Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:riverpod_template/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('{Feature} Integration Tests', () {
    testWidgets('should complete {flow_name} flow', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Navigate through flow
      // 1. Find element
      // 2. Interact
      // 3. Verify result
      // 4. Continue to next step
    });
  });
}
```

### Step 8: Create Mock with Stub Pattern

```dart
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/data/repositories/{feature}_repository/{feature}_repository.dart';

class Mock{Feature}Repository extends Mock implements {Feature}RepositoryInterface {
  /// Stub successful {method}
  void stub{Method}Success({ReturnType} result) {
    when(() => {method}(any())).thenAnswer((_) async => result);
  }

  /// Stub {method} error
  void stub{Method}Error(String message) {
    when(() => {method}(any())).thenThrow(Exception(message));
  }
}
```

### Step 9: Create Test Data

```dart
// test/test_data/{feature}_test_data.dart

import 'package:riverpod_template/domain/{model}/{model}.dart';

/// Factory function with optional overrides
{Model} createTest{Model}({
  String? id,
  String? name,
  // ... other fields
}) => {Model}(
  id: id ?? 'test-id',
  name: name ?? 'Test Name',
);

/// Pre-built constants
class Test{Model}s {
  Test{Model}s._();

  static {Model} get basic => createTest{Model}();
  static {Model} get custom => createTest{Model}(name: 'Custom');
  static List<{Model}> list(int count) => List.generate(
    count,
    (i) => createTest{Model}(id: 'id-$i', name: 'Item $i'),
  );
}
```

### Step 10: Run Tests

```bash
# Run specific test file
flutter test test/presentation/{feature}/{test_file}_test.dart

# Run all tests in directory
flutter test test/presentation/{feature}/

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/{feature}_test.dart
```

### Step 11: Verify Tests Pass

**Expected:**

- ✅ All tests pass
- ✅ No warnings
- ✅ Coverage acceptable (if checked)

**If tests fail:**

- Fix implementation or test
- Re-run tests
- Verify fixes

---

## Test Type Guidelines

### Unit Tests

**When to use:**

- Testing business logic
- Testing controller methods
- Testing repository methods
- Testing utility functions
- Testing model methods

**Characteristics:**

- Fast (<1s per test)
- Isolated (no dependencies)
- Mocked dependencies
- Test one thing at a time

### Widget Tests

**When to use:**

- Testing UI rendering
- Testing user interactions
- Testing widget state changes
- Testing navigation
- Testing form validation

**Characteristics:**

- Medium speed (<5s per test)
- Uses `WidgetTester`
- May need providers
- Tests user-facing behavior

### Integration Tests

**When to use:**

- Testing complete user flows
- Testing API integration
- Testing cross-feature flows
- End-to-end scenarios

**Characteristics:**

- Slower (>5s per test)
- Uses real app instance
- May hit real APIs (or mocked)
- Tests full stack

---

## Best Practices

### Mocking

- **Mock repositories**, not controllers
- Use **mocktail** for mocks
- Use **stub methods** for common scenarios
- Use **ProviderContainer** with overrides for Riverpod testing

### Test Data

- **Use factories** in `test/test_data/`
- Create **TestXxx constants** for reusable data
- Keep test data **realistic**

### Assertions

- **Use specific matchers** (`equals`, `isA`, `throwsA`)
- **Verify behavior, not implementation**
- **Test edge cases** (null, empty, boundaries)
- **Test error cases**

### Organization

- **One test file per source file** (when possible)
- **Group related tests** with `group()`
- **Use descriptive names**: `should {behavior} when {condition}`
- **Keep tests focused** (one assertion per test when possible)

---

## Notes

- **Always run tests** after creating them
- **Keep tests fast** (unit tests <1s, widget tests <5s)
- **Maintain test coverage** on critical paths
- **Update tests** when code changes
- **Use `setUp()` and `tearDown()`** for common setup/cleanup
- **Follow Arrange-Act-Assert** pattern
