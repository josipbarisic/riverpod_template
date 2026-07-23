import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';
import 'package:riverpod_template/core/routing/app_route.dart';
import 'package:riverpod_template/core/routing/router.dart';
import 'package:riverpod_template/core/services/local_notifications_service/local_notifications_service.dart';
import 'package:riverpod_template/core/services/network_service/network_service.dart';
import 'package:riverpod_template/core/utils/network/endpoints.dart';

class FirebaseApi {
  FirebaseApi({
    FirebaseAuth? firebaseAuth,
    FirebaseMessaging? firebaseMessaging,
    required this.networkService,
    required this.localNotificationsService,
    required this.hasRemoteMessage,
  }) {
    this.firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    this.firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;
  }

  late final FirebaseAuth firebaseAuth;
  late final FirebaseMessaging firebaseMessaging;
  final NetworkService networkService;
  final LocalNotificationsService localNotificationsService;
  final HasRemoteMessage hasRemoteMessage;

  // --------------------- Firebase Auth ---------------------

  User? get currentUser => firebaseAuth.currentUser;

  bool get isSignedIn => currentUser != null;

  bool get isAnonymous => currentUser?.isAnonymous ?? true;

  bool get isGoogleLogin => currentUser?.providerData[0].providerId == 'google.com';

  bool get isAppleLogin => currentUser?.providerData[0].providerId == 'apple.com';

  bool get isSocialLogin => isGoogleLogin || isAppleLogin;

  String get userEmail =>
      currentUser?.providerData[0].email ?? currentUser?.email ?? 'Email Hidden';

  /// Sends a password reset email to the specified email address.
  Future<void> sendPasswordResetEmail({required String email}) =>
      firebaseAuth.sendPasswordResetEmail(email: email);

  /// Signs in using the provided authentication credential.
  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      firebaseAuth.signInWithCredential(credential);

  /// Signs out the current user.
  Future<void> signOut() => firebaseAuth.signOut();

  // -------------------- Firebase Messaging --------------------

  Future<String?> getFcmToken() => firebaseMessaging.getToken();

  Future<void> initPushNotifications() async {
    log('Initializing push notifications');
    // Request permission for notifications
    await firebaseMessaging.requestPermission();

    // Fetch the FCM token for the device
    final fcmToken = await firebaseMessaging.getToken();

    // Patch the FCM token to the backend
    if (fcmToken != null) {
      log('FCM token: $fcmToken');
      // await sendFCMToken(fcmToken);
    } else {
      log('FCM token is null');
    }

    await _initNotificationListeners();
  }

  Future<void> sendFCMToken(String token) async {
    try {
      await networkService.postHttp(endpoint: Endpoints.fcmToken, body: {
        'fcmToken': token,
      });
    } catch (e) {
      log('Error sending FCM token to ${Endpoints.fcmToken}: $e');
    }
  }

  Future<void> _initNotificationListeners() async {
    firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        hasRemoteMessage.updateHasRemoteMessage(true);
        log('Handling initial message: ${message.notification?.body}');
        router.push(AppRoute.bottomNavigation, extra: message);
      }
    });

    // Handle notification while in app. If you want to actually show the notification,
    // you need to use the local notifications.
    FirebaseMessaging.onMessage.listen((message) {
      log('Handling message opened app: ${message.notification?.body}');
      hasRemoteMessage.updateHasRemoteMessage(true);
      // router.push(AppRoute.signUp, extra: message);
      localNotificationsService.showRemoteNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      hasRemoteMessage.updateHasRemoteMessage(true);
      log('Handling message opened app: ${message.notification?.body}');
      router.push(AppRoute.signUp, extra: message);
    });
    FirebaseMessaging.onBackgroundMessage(_handleMessage);
  }
}

Future<void> _handleMessage(RemoteMessage message) async {
  log('Handling message: ${message.notification?.body}');

  router.push(AppRoute.login, extra: message);
}
