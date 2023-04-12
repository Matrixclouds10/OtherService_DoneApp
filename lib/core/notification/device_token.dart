import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/logger.dart';

Future<String?> getDeviceToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    log("FCM token:", "$token");

    return token;
  } catch (e) {
    log("FCM token error:", " $e");
    return null;
  }
}
