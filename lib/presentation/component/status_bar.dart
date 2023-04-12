import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBar extends StatelessWidget {
  final Scaffold _child;
  final bool _isDark;
  final Color? _color;
  const StatusBar({
    super.key,
    required Scaffold child,
    bool isDark = false,
    Color? color,
  })  : _child = child,
        _isDark = isDark,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: _color ?? Colors.transparent,
        statusBarIconBrightness: _isDark ? Brightness.dark : Brightness.light,
        statusBarBrightness: _isDark ? Brightness.light : Brightness.dark,
      ),
      child: _child,
    );
  }
}
