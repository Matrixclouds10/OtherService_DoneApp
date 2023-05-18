import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/data/injection.dart';

import '../utils/logger.dart';

Future<String?> getDeviceToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    log("FCM token:", "$token");
    AppPrefs prefs = getIt<AppPrefs>();
    log("token:", "${prefs.get(PrefKeys.token)}}");

    return token;
  } catch (e) {
    log("FCM token error:", " $e");
    return null;
  }
}
