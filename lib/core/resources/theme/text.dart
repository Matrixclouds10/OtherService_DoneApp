import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/font_manager.dart';

/// The `displayColor` is applied to [headline4], [headline3], [headline2],
/// [headline1], and [caption]. The `bodyColor` is applied to the remaining
/// text styles.

// light
TextTheme textThemeLight = ThemeData.light().textTheme.copyWith().apply(
      bodyColor: AppColorLight().kTextSecondaryDark,
      displayColor: AppColorLight().kTextPrimary,
      fontFamily: FontConstants.fontFamily,
    );

// dark
TextTheme textThemeDark = ThemeData.dark().textTheme.copyWith().apply(
      bodyColor: AppColorDark().kTextSecondaryDark,
      displayColor: AppColorDark().kTextPrimary,
      fontFamily: FontConstants.fontFamily,
    );
