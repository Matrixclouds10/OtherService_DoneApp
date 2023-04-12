import 'package:flutter/material.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';

import '../../core/resources/values_manager.dart';

class CustomDivider extends StatelessWidget {
  final double _height;

  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kFormPaddingAllSmall.h),
      height: _height,
      color: _color ?? Theme.of(context).hoverColor,
    );
  }

  const CustomDivider({
    Key? key,
    double height = 1,
    Color? color,
  })  : _height = height,
        _color = color,
        super(key: key);
}
