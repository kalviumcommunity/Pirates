import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> ensureLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<bool> ensureNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
