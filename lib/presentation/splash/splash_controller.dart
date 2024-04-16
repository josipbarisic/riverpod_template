import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_controller.g.dart';

@riverpod
class SplashController extends _$SplashController {
  @override
  FutureOr<void> build() => _fetchInitialData();

  Future<void> _fetchInitialData() async {
    state = const AsyncLoading();
    log('TRIGGERED INITIAL DATA ===> true');
    state = await AsyncValue.guard(() => Future.delayed(
          const Duration(seconds: 3),
          () => true,
        ));
  }
}
