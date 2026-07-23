import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/data/firebase/firebase_api_providers.dart';
import 'package:riverpod_template/core/services/local_notifications_service/local_notifications_service_provider.dart';
import 'package:riverpod_template/core/utils/shared_prefs/shared_prefs_keys.dart';
import 'package:riverpod_template/core/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_controller.g.dart';

@riverpod
class SplashController extends _$SplashController {
  late SharedPreferences _sharedPrefs;

  @override
  FutureOr<void> build() async {
    log('==== CALLING SPLASH CONTROLLER BUILD METHOD =====');
    _sharedPrefs = await ref.watch(sharedPrefsProvider.future);

    return _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    state = const AsyncLoading();

    // 1. Initialize local notifications
    ref.read(localNotificationsServiceProvider).init();
    if (!ref.mounted) return;

    // 2. Initialize push notifications
    await ref.read(firebaseApiProvider).initPushNotifications();
    if (!ref.mounted) return;

    // 3. Test shared preferences
    await _sharedPrefs.setString(SharedPrefsKeys.test, 'testing shared prefs');
    log('FETCH ${SharedPrefsKeys.test} FROM PREFS ===> ${_sharedPrefs.get(SharedPrefsKeys.test)}');
    if (!ref.mounted) return;

    // 4. Set loaded state
    state = await AsyncValue.guard(() => Future.delayed(
          const Duration(seconds: 3),
          () => true,
        ));
  }
}
