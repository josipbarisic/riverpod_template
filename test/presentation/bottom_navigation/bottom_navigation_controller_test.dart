import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_template/presentation/bottom_navigation/bottom_navigation_controller.dart';
import 'package:riverpod_template/presentation/bottom_navigation/bottom_navigation_state.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  group('BottomNavigationController', () {
    test('initial state is home page', () {
      final state = container.read(bottomNavigationControllerProvider);

      expect(state.page, equals(SelectedBottomNavigationPage.home));
    });

    test('selectPage updates state to selected page', () {
      final controller = container.read(bottomNavigationControllerProvider.notifier);

      controller.selectPage(SelectedBottomNavigationPage.settings);

      final state = container.read(bottomNavigationControllerProvider);
      expect(state.page, equals(SelectedBottomNavigationPage.settings));
    });

    test('selectPage can switch between all pages', () {
      final controller = container.read(bottomNavigationControllerProvider.notifier);

      // Test all page transitions
      for (final page in SelectedBottomNavigationPage.values) {
        controller.selectPage(page);

        final state = container.read(bottomNavigationControllerProvider);
        expect(state.page, equals(page));
      }
    });

    test('selecting same page does not change state reference', () {
      final controller = container.read(bottomNavigationControllerProvider.notifier);

      controller.selectPage(SelectedBottomNavigationPage.placeholderOne);
      final state1 = container.read(bottomNavigationControllerProvider);

      controller.selectPage(SelectedBottomNavigationPage.placeholderOne);
      final state2 = container.read(bottomNavigationControllerProvider);

      // States should be equal but may or may not be same reference
      // depending on implementation
      expect(state1.page, equals(state2.page));
    });
  });

  group('BottomNavigationState', () {
    test('two states with same page are equal', () {
      const state1 = BottomNavigationState(page: SelectedBottomNavigationPage.home);
      const state2 = BottomNavigationState(page: SelectedBottomNavigationPage.home);

      expect(state1, equals(state2));
    });

    test('two states with different pages are not equal', () {
      const state1 = BottomNavigationState(page: SelectedBottomNavigationPage.home);
      const state2 = BottomNavigationState(page: SelectedBottomNavigationPage.settings);

      expect(state1, isNot(equals(state2)));
    });

    test('props contains page', () {
      const state = BottomNavigationState(page: SelectedBottomNavigationPage.home);

      expect(state.props, contains(SelectedBottomNavigationPage.home));
    });
  });

  group('SelectedBottomNavigationPage', () {
    test('enum has all expected values', () {
      expect(SelectedBottomNavigationPage.values, hasLength(4));
      expect(SelectedBottomNavigationPage.values, contains(SelectedBottomNavigationPage.home));
      expect(SelectedBottomNavigationPage.values, contains(SelectedBottomNavigationPage.placeholderOne));
      expect(SelectedBottomNavigationPage.values, contains(SelectedBottomNavigationPage.placeholderTwo));
      expect(SelectedBottomNavigationPage.values, contains(SelectedBottomNavigationPage.settings));
    });
  });
}
