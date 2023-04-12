import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weltweit/core/resources/font_manager.dart';

import '../color.dart';
import '../decoration.dart';
import 'app_bar.dart';
import 'bottom_bar.dart';
import 'button.dart';
import 'text.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: FontConstants.fontFamily,
  appBarTheme: appBarThemeLight,
  primaryTextTheme: TextTheme(),
  textTheme: textThemeLight,
  buttonTheme: buttonTheme,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorLight().kBottomNavigationBarColor,
    selectedItemColor: AppColorLight().kAccentColor,
  ),
  hintColor: textSecondary,
  brightness: Brightness.light,
  primaryColor: AppColorLight().kPrimaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: AppColorLight().kScaffoldBackgroundColor,
  cardColor: AppColorLight().kCardColor,
  splashColor: Colors.transparent,
  primaryColorDark: AppColorLight().kPrimaryColorDark,
  primaryColorLight: AppColorLight().kPrimaryColorLight,
  dividerTheme: DividerThemeData(color: AppColorLight().kPrimaryColor),
  inputDecorationTheme: kInputDecorationTheme,
  iconTheme: IconThemeData(color: AppColorLight().kIconsColor),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColorLight().kPrimaryColor,
    onPrimary: AppColorLight().kScaffoldBackgroundColor,
    primaryContainer: AppColorLight().kPrimaryColor,
    onPrimaryContainer: AppColorLight().kScaffoldBackgroundColor,
    inversePrimary: AppColorLight().kPrimaryColor,
    surface: AppColorLight().kScaffoldBackgroundColor,
    onSurface: AppColorLight().kPrimaryColor,
    inverseSurface: AppColorLight().kScaffoldBackgroundColor,
    onInverseSurface: AppColorLight().kPrimaryColor,
    surfaceVariant: AppColorLight().kScaffoldBackgroundColor,
    onSurfaceVariant: AppColorLight().kPrimaryColor,
    secondary: AppColorLight().kAccentColor,
    onSecondary: AppColorLight().kScaffoldBackgroundColor,
    secondaryContainer: AppColorLight().kPrimaryColorDark,
    onSecondaryContainer: AppColorLight().kScaffoldBackgroundColor,
    background: AppColorLight().kScaffoldBackgroundColor,
    onBackground: AppColorLight().kPrimaryColor,
    error: AppColorLight().kErrorColor,
    onError: AppColorLight().kScaffoldBackgroundColor,
    errorContainer: AppColorLight().kErrorColor,
    onErrorContainer: AppColorLight().kScaffoldBackgroundColor,
    tertiary: AppColorLight().kPrimaryColor,
    onTertiary: AppColorLight().kScaffoldBackgroundColor,
    tertiaryContainer: AppColorLight().kPrimaryColor,
    onTertiaryContainer: AppColorLight().kScaffoldBackgroundColor,
    shadow: AppColorLight().kPrimaryColor,
    outline: AppColorLight().kPrimaryColor,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: AppColorDark().kPrimaryColor,
  fontFamily: FontConstants.fontFamily,
  appBarTheme: appBarThemeDark,
  primaryTextTheme: TextTheme(),
  textTheme: textThemeDark,
  buttonTheme: buttonTheme,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorDark().kBottomNavigationBarColor,
    selectedItemColor: AppColorDark().kAccentColor,
  ),
  hintColor: textSecondary,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: AppColorDark().kScaffoldBackgroundColor,
  cardColor: AppColorDark().kCardColor,
  splashColor: AppColorDark().kPrimaryColor,
  primaryColorDark: AppColorDark().kPrimaryColorDark,
  primaryColorLight: AppColorDark().kPrimaryColorLight,
  dividerTheme: DividerThemeData(color: AppColorDark().kPrimaryColor),
  inputDecorationTheme: InputDecorationTheme(),
  iconTheme: IconThemeData(color: AppColorDark().kIconsColor),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorDark().kPrimaryColor,
    onPrimary: AppColorDark().kScaffoldBackgroundColor,
    primaryContainer: AppColorDark().kPrimaryColor,
    onPrimaryContainer: AppColorDark().kScaffoldBackgroundColor,
    inversePrimary: AppColorDark().kPrimaryColor,
    surface: AppColorDark().kScaffoldBackgroundColor,
    onSurface: AppColorDark().kPrimaryColor,
    inverseSurface: AppColorDark().kScaffoldBackgroundColor,
    onInverseSurface: AppColorDark().kPrimaryColor,
    surfaceVariant: AppColorDark().kScaffoldBackgroundColor,
    onSurfaceVariant: AppColorDark().kPrimaryColor,
    secondary: AppColorDark().kAccentColor,
    onSecondary: AppColorDark().kScaffoldBackgroundColor,
    secondaryContainer: AppColorDark().kPrimaryColorDark,
    onSecondaryContainer: AppColorDark().kScaffoldBackgroundColor,
    background: AppColorDark().kScaffoldBackgroundColor,
    onBackground: AppColorDark().kPrimaryColor,
    error: AppColorDark().kErrorColor,
    onError: AppColorDark().kScaffoldBackgroundColor,
    errorContainer: AppColorDark().kErrorColor,
    onErrorContainer: AppColorDark().kScaffoldBackgroundColor,
    tertiary: AppColorDark().kPrimaryColor,
    onTertiary: AppColorDark().kScaffoldBackgroundColor,
    tertiaryContainer: AppColorDark().kPrimaryColor,
    onTertiaryContainer: AppColorDark().kScaffoldBackgroundColor,
    shadow: AppColorDark().kPrimaryColor,
    outline: AppColorDark().kPrimaryColor,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);

ThemeData get servicesTheme {
  Color primaryColor = Colors.orange;
  Color primaryColorDark = Colors.orange[700]!;
  Color primaryColorLight = Colors.orangeAccent;

  Color accentColor = const Color(0xff57A4C3);

  Color scaffoldBackgroundColor = const Color(0xffFDF2E9);
  // Color backgroundColor = Color(0xFF1E1E1E);
  // Color cardColor = Color(0xFF1E1E1E);
  // Color dividerColor = Color(0xFF1E1E1E);
  // Color errorColor = Color(0xFF1E1E1E);
  // Color highlightColor = Color(0xFF1E1E1E);
  // Color hoverColor = Color(0xFF1E1E1E);
  // Color unselectedWidgetColor = Color(0xFF1E1E1E);
  // Color textSecondary = Color(0xFF1E1E1E);

  return ThemeData(
    useMaterial3: true,
    fontFamily: FontConstants.fontFamily,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(250),
      ),
    ),
    appBarTheme: AppBarTheme(
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
    ),
    primaryTextTheme: TextTheme(),
    textTheme: ThemeData.light().textTheme.copyWith().apply(
          bodyColor: AppColorLight().kTextSecondaryDark,
          displayColor: AppColorLight().kTextPrimary,
          fontFamily: FontConstants.fontFamily,
        ),
    buttonTheme: buttonTheme,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorLight().kBottomNavigationBarColor,
      selectedItemColor: AppColorLight().kAccentColor,
    ),
    hintColor: textSecondary,
    brightness: Brightness.light,
    primaryColor: AppColorLight().kPrimaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColorLight().kScaffoldBackgroundColor,
    cardColor: AppColorLight().kCardColor,
    splashColor: Colors.transparent,
    primaryColorDark: AppColorLight().kPrimaryColorDark,
    primaryColorLight: AppColorLight().kPrimaryColorLight,
    dividerTheme: DividerThemeData(color: AppColorLight().kPrimaryColor),
    inputDecorationTheme: kInputDecorationTheme,
    iconTheme: IconThemeData(color: AppColorLight().kIconsColor),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColorLight().kPrimaryColor,
      onPrimary: AppColorLight().kScaffoldBackgroundColor,
      primaryContainer: AppColorLight().kPrimaryColor,
      onPrimaryContainer: AppColorLight().kScaffoldBackgroundColor,
      inversePrimary: AppColorLight().kPrimaryColor,
      surface: AppColorLight().kScaffoldBackgroundColor,
      onSurface: AppColorLight().kPrimaryColor,
      inverseSurface: AppColorLight().kScaffoldBackgroundColor,
      onInverseSurface: AppColorLight().kPrimaryColor,
      surfaceVariant: AppColorLight().kScaffoldBackgroundColor,
      onSurfaceVariant: AppColorLight().kPrimaryColor,
      secondary: AppColorLight().kAccentColor,
      onSecondary: AppColorLight().kScaffoldBackgroundColor,
      secondaryContainer: AppColorLight().kPrimaryColorDark,
      onSecondaryContainer: AppColorLight().kScaffoldBackgroundColor,
      background: AppColorLight().kScaffoldBackgroundColor,
      onBackground: AppColorLight().kPrimaryColor,
      error: AppColorLight().kErrorColor,
      onError: AppColorLight().kScaffoldBackgroundColor,
      errorContainer: AppColorLight().kErrorColor,
      onErrorContainer: AppColorLight().kScaffoldBackgroundColor,
      tertiary: AppColorLight().kPrimaryColor,
      onTertiary: AppColorLight().kScaffoldBackgroundColor,
      tertiaryContainer: AppColorLight().kPrimaryColor,
      onTertiaryContainer: AppColorLight().kScaffoldBackgroundColor,
      shadow: AppColorLight().kPrimaryColor,
      outline: AppColorLight().kPrimaryColor,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    }),
  );
}
