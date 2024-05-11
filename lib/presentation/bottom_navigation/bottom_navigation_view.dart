import 'package:flutter/material.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_template/gen/assets.gen.dart';
import 'package:riverpod_template/presentation/bottom_navigation/bottom_navigation_controller.dart';
import 'package:riverpod_template/presentation/bottom_navigation/bottom_navigation_state.dart';
import 'package:riverpod_template/presentation/home/home_view.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';
import 'package:riverpod_template/theme/helpers/app_icons_helper.dart';

class BottomNavigationView extends HookConsumerWidget {
  const BottomNavigationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final navigationParams =
    //     useMemoized(() => GoRouterState.of(context).extra as NavigationDataObject?);
    final BottomNavigationController controller =
        ref.read(bottomNavigationControllerProvider.notifier);
    final BottomNavigationState state = ref.watch(bottomNavigationControllerProvider);
    return Scaffold(
      bottomNavigationBar: Container(
        constraints: const BoxConstraints(maxHeight: 70),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: lightAppColors.primary500,
              width: 0.5,
            ),
          ),
        ),
        child: Wrap(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                selectedLabelStyle: const TextStyle(fontSize: 0),
                unselectedLabelStyle: const TextStyle(fontSize: 0),
                currentIndex: state.page.index,
                onTap: (pageIndex) =>
                    controller.selectPage(SelectedBottomNavigationPage.values[pageIndex]),
                items: [
                  BottomNavigationBarItem(
                    activeIcon: AppIcons.icon(
                      Assets.icons.appIcon,
                      color: lightAppColors.primary100,
                    ),
                    icon: AppIcons.icon(Assets.icons.appIcon),
                    // Label must be set even if it's not displayed to avoid a bug in the BottomNavigationBarItem
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: AppIcons.icon(
                      Assets.icons.socialGoogle,
                      color: lightAppColors.primary100,
                    ),
                    icon: AppIcons.icon(Assets.icons.socialGoogle),
                    // Label must be set even if it's not displayed to avoid a bug in the BottomNavigationBarItem
                    label: 'Placeholder One',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: AppIcons.icon(
                      Assets.icons.cinnamonLogo,
                      color: lightAppColors.primary100,
                    ),
                    icon: AppIcons.icon(Assets.icons.cinnamonLogo),
                    // Label must be set even if it's not displayed to avoid a bug in the BottomNavigationBarItem
                    label: 'Placeholder Two',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      Icons.settings,
                      color: lightAppColors.primary100,
                    ),
                    icon: const Icon(Icons.settings),
                    // Label must be set even if it's not displayed to avoid a bug in the BottomNavigationBarItem
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: LazyIndexedStack(
        index: state.page.index,
        children: const [
          HomeView(),
          Placeholder(),
          Placeholder(
            child: Center(child: Text('Menu')),
          ),
        ],
      ),
    );
  }
}
