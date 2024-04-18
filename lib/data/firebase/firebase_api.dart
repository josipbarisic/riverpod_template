import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';
import 'package:riverpod_template/routing/router.dart';
import 'package:riverpod_template/services/local_notifications_service/local_notifications_service.dart';
import 'package:riverpod_template/services/network_service/network_service.dart';
import 'package:riverpod_template/utils/network/endpoints.dart';

class FirebaseApi {
  FirebaseApi({
    required this.networkService,
    required this.localNotificationsService,
    required this.hasRemoteMessage,
  });

  final NetworkService networkService;
  final LocalNotificationsService localNotificationsService;
  final HasRemoteMessage hasRemoteMessage;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initPushNotifications() async {
    log('Initializing push notifications');
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Fetch the FCM token for the device
    final fcmToken = await _firebaseMessaging.getToken();

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
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        hasRemoteMessage.updateHasRemoteMessage(true);
        log('Handling initial message: ${message.notification?.body}');
        router.push(RoutePath.home, extra: message);
      }
    });

    // Handle notification while in app. If you want to actually show the notification,
    // you need to use the local notifications.
    FirebaseMessaging.onMessage.listen((message) {
      log('Handling message opened app: ${message.notification?.body}');
      hasRemoteMessage.updateHasRemoteMessage(true);
      // router.push(RoutePath.signUp, extra: message);
      localNotificationsService.showRemoteNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      hasRemoteMessage.updateHasRemoteMessage(true);
      log('Handling message opened app: ${message.notification?.body}');
      router.push(RoutePath.signUp, extra: message);
    });
    FirebaseMessaging.onBackgroundMessage(_handleMessage);
  }
}

Future<void> _handleMessage(RemoteMessage message) async {
  log('Handling message: ${message.notification?.body}');

  router.push(RoutePath.login, extra: message);
}
