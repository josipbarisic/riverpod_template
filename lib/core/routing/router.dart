import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_template/core/routing/app_route.dart';
import 'package:riverpod_template/presentation/bottom_navigation/bottom_navigation_view.dart';
import 'package:riverpod_template/presentation/login/login_view.dart';
import 'package:riverpod_template/presentation/onboarding/onboarding_view.dart';
import 'package:riverpod_template/presentation/sign_up/sign_up_view.dart';
import 'package:riverpod_template/presentation/splash/splash_view.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoute.splash,
  observers: [SimpleNavigationObserver()],
  routes: <RouteBase>[
    GoRoute(
      path: AppRoute.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
      routes: const <RouteBase>[],
    ),
    GoRoute(
      path: AppRoute.onboarding,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingView();
      },
      routes: const <RouteBase>[],
    ),
    GoRoute(
      path: AppRoute.signUp,
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpView();
      },
      routes: const <RouteBase>[],
    ),
    GoRoute(
      path: AppRoute.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginView();
      },
      routes: const <RouteBase>[],
    ),
    GoRoute(
      path: AppRoute.bottomNavigation,
      builder: (BuildContext context, GoRouterState state) {
        return const BottomNavigationView();
      },
      routes: const <RouteBase>[],
    ),
  ],
);

extension GoRouterExtension on GoRouter {
  void pushAndRemoveUntil(String path, [Object? data]) {
    while (canPop()) {
      pop();
    }
    pushReplacement(path, extra: data);
  }
}

class SimpleNavigationObserver extends RouteObserver {
  static String? currentRoute = AppRoute.splash;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) currentRoute = route.settings.name;
    super.didPush(route, previousRoute);
  }
}
