import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route platformPageRoute(Widget screen) {
  return Platform.isAndroid
      ? MaterialPageRoute(builder: (_) => screen)
      : CupertinoPageRoute(builder: (_) => screen);
}
