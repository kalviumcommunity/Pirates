import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> ensureLocationPermission() async {
    if (kIsWeb) {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    }

    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<bool> ensureNotificationPermission() async {
    if (kIsWeb) {
      return true;
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
