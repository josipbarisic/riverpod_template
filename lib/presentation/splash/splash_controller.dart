import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/utils/shared_prefs/shared_prefs_keys.dart';
import 'package:riverpod_template/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_controller.g.dart';

@riverpod
class SplashController extends _$SplashController {
  late SharedPreferences _sharedPrefs;

  @override
  FutureOr<void> build() {
    _sharedPrefs = ref.watch(sharedPrefsProvider).value!;
    return _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    state = const AsyncLoading();

    await _sharedPrefs.setString(SharedPrefsKeys.test, 'testing shared prefs');

    log('FETCH ${SharedPrefsKeys.test} FROM PREFS ===> ${_sharedPrefs.get(SharedPrefsKeys.test)}');

    state = await AsyncValue.guard(() => Future.delayed(
          const Duration(seconds: 3),
          () => true,
        ));
  }
}
