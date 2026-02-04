final class Endpoints {
  static const String users = '/users';
  static const String fcmToken = '/auth/fcm-token';

  static String user(int id) => '$users/$id';
}
