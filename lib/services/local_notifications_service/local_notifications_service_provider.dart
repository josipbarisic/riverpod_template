import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/services/local_notifications_service/local_notifications_service.dart';
import 'package:riverpod_template/utils/shared_prefs/shared_prefs_provider.dart';

part 'local_notifications_service_provider.g.dart';

@Riverpod(keepAlive: true)
LocalNotificationsService localNotificationsService(LocalNotificationsServiceRef ref) =>
    LocalNotificationsService(ref.watch(sharedPrefsProvider).requireValue);
