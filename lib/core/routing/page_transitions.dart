import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Premium page transitions for polished UX.
///
/// Usage in router:
/// ```dart
/// GoRoute(
///   path: '/premium',
///   pageBuilder: (context, state) => RevealTransition.page(
///     key: state.pageKey,
///     child: const PremiumView(),
///   ),
/// )
/// ```

/// Elegant reveal transition: fade + scale + subtle vertical slide.
/// Use for premium feature screens that deserve a "moment".
class RevealTransition extends CustomTransitionPage<void> {
  RevealTransition({required super.key, required super.child})
      : super(
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1.0).animate(curvedAnimation),
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
            );
          },
        );

  /// Factory constructor for cleaner router syntax.
  static RevealTransition page({required LocalKey key, required Widget child}) =>
      RevealTransition(key: key, child: child);
}

/// Smooth modal-style rise: slide up from bottom + fade.
/// Use for form screens, data entry, or "next step" flows.
class ModalRiseTransition extends CustomTransitionPage<void> {
  ModalRiseTransition({required super.key, required super.child})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
              reverseCurve: const Interval(0.3, 1.0, curve: Curves.easeIn),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.12),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );

  /// Factory constructor for cleaner router syntax.
  static ModalRiseTransition page({required LocalKey key, required Widget child}) =>
      ModalRiseTransition(key: key, child: child);
}

/// Gentle fade transition for subtle screen changes.
/// Use for settings, profile, or secondary screens.
class GentleFadeTransition extends CustomTransitionPage<void> {
  GentleFadeTransition({required super.key, required super.child})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ),
              child: child,
            );
          },
        );

  /// Factory constructor for cleaner router syntax.
  static GentleFadeTransition page({required LocalKey key, required Widget child}) =>
      GentleFadeTransition(key: key, child: child);
}
