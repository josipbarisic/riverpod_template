import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';
import 'package:riverpod_template/gen/assets.gen.dart';
import 'package:riverpod_template/presentation/splash/splash_controller.dart';
import 'package:riverpod_template/routing/router.dart';
import 'package:riverpod_template/theme/helpers/app_icons_helper.dart';
import 'package:riverpod_template/utils/enums/hero_animations_enum.dart';
import 'package:riverpod_template/utils/mixins/theme_mixin.dart';

class SplashView extends ConsumerWidget with ThemeMixin {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      splashControllerProvider,
      // If app was started from the background notification, do not navigation to the
      // Onboarding screen.
      (_, next) => next.hasValue && !ref.read(hasRemoteMessageProvider)
          ? GoRouter.of(context).go(RoutePath.onboarding)
          : null,
      onError: (error, _) => log('Error on loading Splash data: $error'),
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: HeroAnimations.splashLogo,
              child: AppIcons.icon(
                Assets.icons.appIcon,
                size: 80,
              ),
            ),
            Text('HAS MSG:${ref.watch(hasRemoteMessageProvider)}'),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              color: theme(context).secondaryHeaderColor,
            )
          ],
        ),
      ),
    );
  }
}
