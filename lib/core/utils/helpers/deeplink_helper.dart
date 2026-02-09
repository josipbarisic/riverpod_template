import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_template/core/routing/app_route.dart';
import 'package:riverpod_template/core/routing/router.dart';
import 'package:riverpod_template/core/utils/shared_prefs/shared_prefs_keys.dart';
import 'package:riverpod_template/models/user/user.dart' as domain;
import 'package:shared_preferences/shared_preferences.dart';

/// Generic deeplink handler.
///
/// Subclass or extend [parseDeeplink] to add app-specific routes.
///
/// Supports:
/// - Parsing deeplink paths into route navigation data
/// - Auth-gated navigation (protected routes)
/// - Pending deeplink storage (navigate after login)
/// - Firebase Auth callback filtering
class DeeplinkHelper {
  /// Parses a deeplink path and returns navigation information.
  ///
  /// Returns a map with:
  /// - `routeName`: The route name to navigate to
  /// - `pathParameters`: Map of path parameters
  /// - `extra`: Optional extra data to pass to the route
  ///
  /// Returns null if the deeplink cannot be parsed or is not supported.
  ///
  /// Override this method to add your own deeplink routes.
  static Map<String, dynamic>? parseDeeplink({
    required String path,
    Map<String, String>? queryParameters,
  }) {
    log('Parsing deeplink - path: $path, queryParams: $queryParameters');

    // Ignore Firebase Auth internal callbacks
    if (isFirebaseAuthCallback(path: path, queryParameters: queryParameters)) {
      log('Ignoring Firebase Auth callback deeplink');
      return null;
    }

    // Remove leading slash if present
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final pathSegments = cleanPath.split('/').where((s) => s.isNotEmpty).toList();

    if (pathSegments.isEmpty) {
      log('Deeplink path is empty');
      return null;
    }

    // -------------------------------------------------------
    // Add your route-specific parsers here. Example:
    //
    // if (pathSegments.first == 'profile') {
    //   return {
    //     'routeName': AppRoute.profile,
    //     'pathParameters': <String, String>{},
    //   };
    // }
    // -------------------------------------------------------

    log('Unsupported deeplink path: $path');
    return null;
  }

  /// Returns true if the deeplink is a Firebase Auth internal callback
  /// (e.g. reCAPTCHA verification during phone auth on iOS).
  /// These should be silently ignored — Firebase Auth SDK handles them internally.
  static bool isFirebaseAuthCallback({
    required String path,
    Map<String, String>? queryParameters,
  }) {
    if (path == '/link' || path == 'link') {
      final deepLinkId = queryParameters?['deep_link_id'] ?? '';
      if (deepLinkId.contains('firebaseauth') || deepLinkId.contains('authType=verifyApp')) {
        return true;
      }
    }
    return false;
  }

  // -------------------- Protected Routes --------------------

  /// Routes that require authentication. Add your protected routes here.
  static final Set<String> _protectedRoutes = {
    AppRoute.bottomNavigation,
  };

  /// Whether [routeName] requires a logged-in user.
  static bool isProtectedRoute(String? routeName) {
    if (routeName == null) return false;
    return _protectedRoutes.contains(routeName);
  }

  /// Whether the user is authenticated (Firebase + domain user present).
  static bool isUserAuthenticated(domain.User? user) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser != null && user != null;
  }

  // -------------------- Pending Deeplink --------------------

  /// Stores a pending deeplink to navigate after login.
  static Future<void> storePendingDeeplink({
    required String path,
    Map<String, String>? queryParameters,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsKeys.pendingDeeplinkPath, path);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      await prefs.setString(SharedPrefsKeys.pendingDeeplinkParams, jsonEncode(queryParameters));
    } else {
      await prefs.remove(SharedPrefsKeys.pendingDeeplinkParams);
    }
    log('Stored pending deeplink - path: $path');
  }

  /// Clears any pending deeplink.
  static Future<void> clearPendingDeeplink() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefsKeys.pendingDeeplinkPath);
    await prefs.remove(SharedPrefsKeys.pendingDeeplinkParams);
    log('Cleared pending deeplink');
  }

  /// Retrieves and clears the pending deeplink (returns null if none stored).
  static Future<Map<String, dynamic>?> getPendingDeeplink() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(SharedPrefsKeys.pendingDeeplinkPath);

    if (path == null || path.isEmpty) return null;

    final paramsJson = prefs.getString(SharedPrefsKeys.pendingDeeplinkParams);
    Map<String, String>? queryParameters;
    if (paramsJson != null) {
      try {
        final decoded = jsonDecode(paramsJson) as Map<String, dynamic>;
        queryParameters = decoded.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        log('Error parsing pending deeplink params: $e');
      }
    }

    await clearPendingDeeplink();
    log('Retrieved pending deeplink - path: $path');

    return {'path': path, 'queryParameters': queryParameters};
  }

  // -------------------- Navigation --------------------

  /// Navigates using parsed deeplink data with an authentication check.
  ///
  /// If the route is protected and the user is unauthenticated, the deeplink
  /// is stored as pending and `false` is returned.
  static Future<bool> navigateFromDeeplinkWithAuthCheck({
    required BuildContext? context,
    required Map<String, dynamic> deeplinkData,
    required domain.User? user,
    required String deeplinkPath,
    Map<String, String>? deeplinkQueryParams,
  }) async {
    final routeName = deeplinkData['routeName'] as String;

    final shouldAllow = await shouldAllowNavigation(
      routeName: routeName,
      deeplinkPath: deeplinkPath,
      deeplinkQueryParams: deeplinkQueryParams,
      user: user,
    );

    if (!shouldAllow) return false;

    if (context != null && context.mounted) {
      navigateFromDeeplink(context, deeplinkData);
    } else {
      final pathParameters = deeplinkData['pathParameters'] as Map<String, String>? ?? {};
      final extra = deeplinkData['extra'];
      log('Navigating from deeplink (no context) - route: $routeName');
      router.goNamed(routeName, pathParameters: pathParameters, extra: extra);
    }
    return true;
  }

  /// Navigates using parsed deeplink data (no auth check).
  static void navigateFromDeeplink(BuildContext context, Map<String, dynamic> deeplinkData) {
    final routeName = deeplinkData['routeName'] as String;
    final pathParameters = deeplinkData['pathParameters'] as Map<String, String>? ?? {};
    final extra = deeplinkData['extra'];

    log('Navigating from deeplink - route: $routeName, params: $pathParameters');
    context.goNamed(routeName, pathParameters: pathParameters, extra: extra);
  }

  /// Returns true if navigation should proceed.
  ///
  /// If the route is protected and the user is unauthenticated, stores
  /// the deeplink as pending and returns false.
  static Future<bool> shouldAllowNavigation({
    required String routeName,
    required String deeplinkPath,
    Map<String, String>? deeplinkQueryParams,
    domain.User? user,
  }) async {
    if (!isProtectedRoute(routeName)) return true;

    if (!isUserAuthenticated(user)) {
      log('Protected route $routeName requires authentication, storing deeplink as pending');
      await storePendingDeeplink(path: deeplinkPath, queryParameters: deeplinkQueryParams);
      return false;
    }

    await clearPendingDeeplink();
    return true;
  }
}
