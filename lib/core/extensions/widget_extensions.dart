import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  ltr() => Directionality(textDirection: TextDirection.ltr, child: this);
}
