import 'dart:developer';

import 'package:flutter/foundation.dart';

kEcho(String text) {
  if (kDebugMode) log('✅ $text');
  // if(Platform.isIOS) print('✅ $text');
}
kEchoUpdate(String text) {
  if (kDebugMode) log('✅✅ $text');
  // if(Platform.isIOS) print('✅ $text');
}

kEcho100(String text) {
  if (kDebugMode) log('💯 $text');

  // if(Platform.isIOS) print('💯 $text');
}

kEchoError(dynamic text) {
  if (kDebugMode) log('❌ $text');
  // if(Platform.isIOS) print('❌ $text');
}

kEchoSearch(String text) {
  if (kDebugMode) log('🔎 $text');
  // if(Platform.isIOS) print('🔎 $text');
}
