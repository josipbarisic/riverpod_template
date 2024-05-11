import 'package:flutter/material.dart';
import 'package:riverpod_template/gen/assets.gen.dart';
import 'package:riverpod_template/theme/helpers/app_icons_helper.dart';
import 'package:riverpod_template/utils/enums/hero_animations_enum.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.body,
    super.key,
  });

  final Widget? body;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 50,
                          ),
                          child: Row(
                            children: [
                              Hero(
                                tag: HeroAnimations.splashLogo,
                                child: AppIcons.icon(
                                  Assets.icons.appIcon,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (body != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: body!,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
