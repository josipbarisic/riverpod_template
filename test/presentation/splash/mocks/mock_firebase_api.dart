import 'package:mocktail/mocktail.dart';
import 'package:riverpod_template/data/firebase/firebase_api.dart';

/// Mock implementation of [FirebaseApi] for testing.
class MockFirebaseApi extends Mock implements FirebaseApi {
  /// Stub successful push notification initialization
  void stubInitPushNotifications() {
    when(() => initPushNotifications()).thenAnswer((_) async {});
  }

  /// Stub push notification initialization with error
  void stubInitPushNotificationsError(Exception error) {
    when(() => initPushNotifications()).thenThrow(error);
  }

  /// Stub successful FCM token send
  void stubSendFCMTokenSuccess() {
    when(() => sendFCMToken(any())).thenAnswer((_) async {});
  }

  /// Stub FCM token send with error
  void stubSendFCMTokenError(Exception error) {
    when(() => sendFCMToken(any())).thenThrow(error);
  }
}
