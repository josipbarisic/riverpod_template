import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/data/firebase/firebase_api.dart';
import 'package:riverpod_template/services/local_notifications_service/local_notifications_service_provider.dart';
import 'package:riverpod_template/services/network_service/network_service_providers.dart';

part 'firebase_api_providers.g.dart';

@Riverpod(keepAlive: true)
FirebaseApi firebaseApi(FirebaseApiRef ref) => FirebaseApi(
      networkService: ref.watch(networkServiceProvider),
      localNotificationsService: ref.watch(localNotificationsServiceProvider),
      hasRemoteMessage: ref.read(hasRemoteMessageProvider.notifier),
    );

@riverpod
class HasRemoteMessage extends _$HasRemoteMessage {
  @override
  bool build() => false;

  void updateHasRemoteMessage(bool value) => state = value;
}
