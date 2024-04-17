import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_template/data/notifications/app_notification.dart';
import 'package:riverpod_template/data/notifications/notification_status.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  LocalNotificationsService(this.sharedPrefs);

  final SharedPreferences sharedPrefs;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(onDidReceiveLocalNotification: (id, _, __, ___) {});

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {});
  }

  Future<NotificationStatus> requestPermission() async {
    try {
      final disabledByUser = await getDisabledByUser();
      if (disabledByUser) {
        log("this should not have been called");
        return NotificationStatus(await Permission.notification.status, disabledByUser);
      }
      final status = await Permission.notification.request();

      return NotificationStatus(status, disabledByUser);
    } catch (e) {
      log("Notification Service Request Permission Error: $e");
      return const NotificationStatus(PermissionStatus.denied, false);
    }
  }

  Future<void> scheduleNotifications(List<AppNotification> notifications) async {
    await cancelAll();
    bool isDisabled = await getDisabledByUser();
    if (isDisabled) {
      return;
    }
    await Future.wait(notifications.mapIndexed(_schedule));
  }

  Future<List<ActiveNotification>> getActiveNotifications() =>
      _flutterLocalNotificationsPlugin.getActiveNotifications();

  Future<List<PendingNotificationRequest>> getPendingNotifications() =>
      _flutterLocalNotificationsPlugin.pendingNotificationRequests();

  Future<void> cancelAll({bool leaveActiveNotifications = true}) async {
    List<ActiveNotification> activeNotifications = await getActiveNotifications();
    List<int> activeNotificationsIDs = activeNotifications.map((e) => e.id ?? -1).toList();
    List<PendingNotificationRequest> pendingNotifications = await getPendingNotifications();

    if (leaveActiveNotifications) {
      await Future.wait(pendingNotifications
          .whereNot((pn) => activeNotificationsIDs.contains(pn.id))
          .map((e) => _flutterLocalNotificationsPlugin.cancel(e.id)));
    } else {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _schedule(int index, AppNotification element) async {
    final date = tz.TZDateTime.from(element.scheduledDate, tz.local);

    if (date.isBefore(DateTime.now())) return;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        index + 1,
        element.title,
        element.description,
        date,
        NotificationDetails(
          /// Adding channelId and channelName prevents notifications scheduling exception from being thrown.
          /// If necessary, change the id and the name parameter to match the rest of the config.
          android: AndroidNotificationDetails(
            'channel_id',
            'notifications_channel',
            color: lightAppColors.primary100,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime);
  }

  Future<PermissionStatus> getPermission() async {
    return await Permission.notification.status;
  }

  Future<bool> getDisabledByUser() async {
    return await Future.value(sharedPrefs.getBool('disabledByUser') ?? false);
  }

  Future<void> setDisabledByUser(bool value) async {
    await sharedPrefs.setBool('disabledByUser', value);
  }
}
