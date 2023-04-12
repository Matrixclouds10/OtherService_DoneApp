import 'package:flutter/material.dart';

import '../color.dart';

// button theme
const buttonTheme = ButtonThemeData(
  buttonColor: colorButton,
  textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
  // colorScheme: ButtonTextTheme.primary,
);
const buttonThemeDark = ButtonThemeData(
  buttonColor: colorButtonDark,
  textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
);
