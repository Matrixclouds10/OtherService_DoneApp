import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weltweit/core/resources/color.dart';

AppBarTheme appBarThemeLight = AppBarTheme(
  color: Colors.transparent,
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: AppColorLight().kStatusBarColor,
    systemNavigationBarColor: AppColorLight().kAppBarColor,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ),
  toolbarTextStyle: TextStyle(
    color: AppColorLight().kAppBarIconsColor,
  ),
  iconTheme: IconThemeData(
    color: AppColorLight().kAppBarIconsColor,
  ),
);
AppBarTheme appBarThemeDark = AppBarTheme(
  color: kAppBarColor,
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: AppColorDark().kStatusBarColor,
    systemNavigationBarColor: AppColorLight().kAppBarColor,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ),
  toolbarTextStyle: TextStyle(color: AppColorDark().kAppBarIconsColor),
  iconTheme: IconThemeData(
    color: AppColorDark().kAppBarIconsColor,
  ),
);
