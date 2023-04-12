import 'package:flutter/material.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';

import '../resources/color.dart';
import '../resources/resources.dart';

extension TextCustom on TextStyle {
  TextStyle activeColor() => (this).copyWith(color: primaryColor);
  TextStyle customColor(Color color) => (this).copyWith(color: color);
  TextStyle colorWhite() => (this).copyWith(color: Colors.white);
  TextStyle activeLiteColor() => (this).copyWith(color: primaryColorLight);
  TextStyle activeDarkColor() => (this).copyWith(color: primaryColorDark);
  TextStyle errorStyle() => (this).copyWith(color: errorColor);
  TextStyle hintStyle() => (this).copyWith(color: textSecondary);
  TextStyle textFamily({String? fontFamily}) => (this).copyWith(fontFamily: fontFamily);
  TextStyle darkTextStyle() => (this).copyWith(color: textPrimaryDark);
  TextStyle boldActiveStyle() => (this).copyWith(fontWeight: FontWeight.bold, color: primaryColor);
  TextStyle boldStyle() => (this).copyWith(fontWeight: FontWeight.bold);
  TextStyle boldBlackStyle() => (this).copyWith(fontWeight: FontWeight.bold, color: Colors.black);
  TextStyle boldLiteStyle() => (this).copyWith(fontWeight: FontWeight.w500);
  TextStyle blackStyle() => (this).copyWith(color: Colors.black);
  TextStyle underLineStyle() => (this).copyWith(decoration: TextDecoration.underline);
  TextStyle ellipsisStyle({int line = 1}) => (this).copyWith(
        overflow: TextOverflow.ellipsis,
      );
  TextStyle heightStyle({double height = 1}) => (this).copyWith(height: height);

  TextStyle semiBoldStyle({double height = 1}) => (this).copyWith(
        fontWeight: FontWeight.w600,
      );

  TextStyle titleStyle({double fontSize = 16}) => (this).copyWith(fontSize: fontSize.sp, color: textPrimary, fontWeight: FontWeight.w700, fontFamily: FontConstants.fontFamily);
  TextStyle regularStyle({double fontSize = 14}) => (this).copyWith(fontSize: fontSize.sp, color: textPrimary, fontWeight: FontWeight.w400, fontFamily: FontConstants.fontFamily);
  TextStyle descriptionStyle({double fontSize = 12}) => (this).copyWith(fontSize: fontSize.sp, color: textSecondary, fontWeight: FontWeight.w300, fontFamily: FontConstants.fontFamily);
}
