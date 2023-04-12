import 'package:flutter/material.dart';

import '../../resources/font_manager.dart';
import '../color.dart';

BottomNavigationBarThemeData bottomNavigationBarTheme =
    const BottomNavigationBarThemeData(
  backgroundColor: primaryColor,
  elevation: 0,
  selectedItemColor: navIconSelected,
  unselectedItemColor: navIconUnselected,
  selectedLabelStyle: TextStyle(fontFamily: FontConstants.fontFamily),
  unselectedLabelStyle: TextStyle(fontFamily: FontConstants.fontFamily),
);

BottomNavigationBarThemeData bottomNavigationBarThemeDark =
    const BottomNavigationBarThemeData(
  selectedItemColor: navIconSelectedDark,
  unselectedItemColor: navIconUnselectedDark,
);
