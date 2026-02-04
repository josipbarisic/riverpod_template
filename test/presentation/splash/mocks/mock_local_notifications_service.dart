import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_template/services/local_notifications_service/local_notifications_service.dart';
import 'package:riverpod_template/utils/notifications/app_notification.dart';
import 'package:riverpod_template/utils/notifications/notification_status.dart';

/// Mock implementation of [LocalNotificationsService] for testing.
class MockLocalNotificationsService extends Mock implements LocalNotificationsService {
  /// Stub successful initialization
  void stubInit() {
    when(() => init()).thenAnswer((_) async {});
  }

  /// Stub initialization with error
  void stubInitError(Exception error) {
    when(() => init()).thenThrow(error);
  }

  /// Stub permission request with granted status
  void stubRequestPermissionGranted() {
    when(() => requestPermission()).thenAnswer(
      (_) async => const NotificationStatus(PermissionStatus.granted, false),
    );
  }

  /// Stub permission request with denied status
  void stubRequestPermissionDenied() {
    when(() => requestPermission()).thenAnswer(
      (_) async => const NotificationStatus(PermissionStatus.denied, false),
    );
  }

  /// Stub permission check
  void stubGetPermission(PermissionStatus status) {
    when(() => getPermission()).thenAnswer((_) async => status);
  }

  /// Stub getDisabledByUser
  void stubGetDisabledByUser(bool value) {
    when(() => getDisabledByUser()).thenReturn(value);
  }

  /// Stub schedule notifications
  void stubScheduleNotifications() {
    when(() => scheduleNotifications(any())).thenAnswer((_) async {});
  }

  /// Stub cancel all notifications
  void stubCancelAll() {
    when(() => cancelAll(leaveActiveNotifications: any(named: 'leaveActiveNotifications')))
        .thenAnswer((_) async {});
  }

  /// Stub get active notifications
  void stubGetActiveNotifications(List<ActiveNotification> notifications) {
    when(() => getActiveNotifications()).thenAnswer((_) async => notifications);
  }

  /// Stub get pending notifications
  void stubGetPendingNotifications(List<PendingNotificationRequest> requests) {
    when(() => getPendingNotifications()).thenAnswer((_) async => requests);
  }
}
