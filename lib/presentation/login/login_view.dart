import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';
import 'package:riverpod_template/gen/assets.gen.dart';
import 'package:riverpod_template/theme/helpers/app_icons_helper.dart';
import 'package:riverpod_template/utils/enums/hero_animations_enum.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const Text('LOGIN SCREEN'),
            Text('HAS MSG ==> ${ref.watch(hasRemoteMessageProvider)}'),
          ],
        ),
      ),
    );
  }
}
