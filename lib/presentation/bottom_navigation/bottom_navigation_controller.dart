import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/presentation/bottom_navigation/bottom_navigation_state.dart';

part 'bottom_navigation_controller.g.dart';

@Riverpod(keepAlive: true)
class BottomNavigationController extends _$BottomNavigationController {
  @override
  BottomNavigationState build() {
    return const BottomNavigationState(page: SelectedBottomNavigationPage.home);
  }

  void selectPage(SelectedBottomNavigationPage page) {
    state = BottomNavigationState(page: page);
  }
}
