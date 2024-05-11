import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_template/presentation/widgets/onboarding_scaffold.dart';
import 'package:riverpod_template/routing/router.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';
import 'package:riverpod_template/utils/app_strings.dart';
import 'package:riverpod_template/utils/mixins/theme_mixin.dart';
import 'package:riverpod_template/utils/shared_prefs/shared_prefs_keys.dart';
import 'package:riverpod_template/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends HookConsumerWidget with ThemeMixin {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final isLastPage = useState(false);

    final sharedPrefs = ref.watch(sharedPrefsProvider).value;
    useEffect(() {
      if (sharedPrefs?.getBool(SharedPrefsKeys.onboardingFlowDone) != true) {
        sharedPrefs?.setBool(SharedPrefsKeys.onboardingFlowDone, true);
      }
      return null;
    }, [
      isLastPage.value,
      sharedPrefs?.getBool(SharedPrefsKeys.onboardingFlowDone),
    ]);

    return OnboardingScaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) => isLastPage.value = value == 3,
              children: const [
                Placeholder(
                  child: Center(
                    child: Text('Onboarding Page One'),
                  ),
                ),
                Placeholder(
                  child: Center(
                    child: Text('Onboarding Page Two'),
                  ),
                ),
                Placeholder(
                  child: Center(
                    child: Text('Onboarding Page Three'),
                  ),
                ),
                Placeholder(
                  child: Center(
                    child: Text('Onboarding Page Four'),
                  ),
                ),
              ],
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  effect: ExpandingDotsEffect(
                    dotWidth: 8,
                    dotHeight: 8,
                    dotColor: lightAppColors.primary100,
                  ),
                  count: 4,
                ),
                GestureDetector(
                  onTap: () => !isLastPage.value
                      ? pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        )
                      : GoRouter.of(context).push(RoutePath.signUp),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      !isLastPage.value ? AppStrings.next : AppStrings.getStarted,
                      style: theme(context).textTheme.bodyMedium?.copyWith(
                            letterSpacing: 1.92,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
