import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationStatus extends Equatable {
  final bool disabledByUser;

  final PermissionStatus permissionStatus;

  const NotificationStatus(this.permissionStatus, this.disabledByUser);

  @override
  List<Object?> get props => [permissionStatus, disabledByUser];
}
