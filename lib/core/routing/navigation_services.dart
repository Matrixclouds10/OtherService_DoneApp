import 'package:flutter/widgets.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/base_injection.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static Future<dynamic> push(String route,
      {Map<String, dynamic>? arguments}) async {
    return await Navigator.pushNamed(navigationKey.currentContext!, route,
        arguments: arguments);
  }

  static Future<dynamic> pushReplacement(String route,
      {Map<String, dynamic>? arguments}) async {
    return await Navigator.pushReplacementNamed(
        navigationKey.currentContext!, route,
        arguments: arguments);
  }

  static Future<dynamic> pushNamedAndRemoveUntil(String route,
      {Map<String, dynamic>? arguments}) async {
    return await Navigator.pushNamedAndRemoveUntil(
        navigationKey.currentContext!, route, (route) => false,
        arguments: arguments);
  }

  static dynamic goBack([Object? result]) {
    return Navigator.pop(navigationKey.currentContext!, result);
  }

  static void logout() {
    AppPrefs prefs = getIt();
    prefs.clear();
    prefs.deleteSecuredData();
    Navigator.pushNamedAndRemoveUntil(
        navigationKey.currentContext!, '/', (route) => false);
  }
}
