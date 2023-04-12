import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      return false;
    }

    return true;
  }

  static Future<bool?> requestLocation() async {
    final status = await Permission.location.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    return true;
  }

  static Future<bool> checkLocationPermissionStatus() async {
    final status = await Permission.location.status;
    return status.isGranted || status.isLimited;
  }
}
