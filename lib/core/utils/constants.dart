import 'package:flutter/foundation.dart';

class Constants {
  static const String empty = "";
  static const int connectTimeout = kDebugMode ? 15000 : 120000;
  //TODO check before deploy
  static bool hideForIos = true;
}
