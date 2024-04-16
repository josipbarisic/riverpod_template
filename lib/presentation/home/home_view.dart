import 'package:flutter/material.dart';
import 'package:riverpod_template/data/enums/hero_animations_enum.dart';
import 'package:riverpod_template/gen/assets.gen.dart';
import 'package:riverpod_template/theme/helpers/app_icons_helper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: Row(
                children: [
                  Hero(
                    tag: HeroAnimations.splashLogo,
                    child: AppIcons.icon(
                      Assets.icons.appIcon,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 250),
            const Text('HOME SCREEN'),
          ],
        ),
      ),
    );
  }
}