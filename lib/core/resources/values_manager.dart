import 'package:flutter/material.dart';

final size = MediaQueryData.fromView(WidgetsBinding.instance.window);
final deviceHeight = size.size.height;
final deviceWidth = size.size.width;

const double kFormPaddingVertical = 12.0;
const double kFormPaddingHorizontal = 12.0;
const double kScreenPaddingNormal = 16.0;
const double kScreenPaddingLarge = 32.0;
const double kFormPaddingAllSmall = 4.0;
const double kFormPaddingAllLarge = 8.0;
const double kLoadingIndicatorSize = 32.0;
const double kTextFieldIconSize = 24.0;
const double kTextFieldIconSizeLarge = 32.0;
const double kAppbarTextSize = 18.0;

///Radius
const double kFormRadiusSmall = 10.0;
const double kFormRadius = 16.0;
const double kFormRadiusLarge = 30.0;
