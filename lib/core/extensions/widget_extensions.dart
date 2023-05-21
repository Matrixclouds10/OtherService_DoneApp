import 'package:flutter/material.dart';

import '../services/responsive_service.dart';

extension WidgetExtension on Widget {
  ltr() => Directionality(textDirection: TextDirection.ltr, child: this);
}
