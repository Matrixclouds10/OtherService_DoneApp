import 'package:flutter/cupertino.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base_form.dart';

class CustomTextFieldSearch extends StatelessWidget {
  final String? suffixText;
  final String? hint;
  final String? defaultValue;
  final bool enable;
  final String? label;
  final Color? prefixIconColor;
  final bool autoValidate;
  final bool noBorder;
  final bool isRequired;
  final VoidCallback? onTap;
  final int? lines;
  final ValueChanged<String>? onChange;
  final GestureTapCallback? onFilterTap;
  final Function? validateFunc;
  final Function? onSubmit;
  final IconData? iconData;
  final IconData? suffixIconData;
  final Widget? suffixDataWidget;
  final double? fontSize;
  final bool isDarkBackground;
  final bool? readOnly;
  final bool isSearch;
  final double? radius;
  final double? contentPaddingH;
  final List<TextInputFormatter>? formatter;
  final Color? background;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const CustomTextFieldSearch({
    Key? key,
    this.background,
    this.iconData,
    this.defaultValue,
    this.onFilterTap,
    this.hint,
    this.onTap,
    this.prefixIconColor,
    this.autoValidate = false,
    this.enable = true,
    this.noBorder = false,
    this.isDarkBackground = false,
    this.isRequired = true,
    this.label,
    this.readOnly,
    this.contentPaddingH,
    this.lines,
    this.fontSize,
    this.radius,
    this.isSearch = true,
    this.onChange,
    this.suffixIconData,
    this.validateFunc,
    this.suffixText,
    this.formatter,
    this.controller,
    this.suffixDataWidget,
    this.onSubmit,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      background: CupertinoColors.tertiarySystemFill,
      prefixIcon: iconData ?? Icons.search,
      prefixIconColor: prefixIconColor ?? Theme.of(context).primaryColor,
      defaultValue: defaultValue,
      hint: hint ?? tr(LocaleKeys.searchHint),
      onTap: onTap,
      autoValidate: autoValidate,
      enable: enable,
      textInputAction: TextInputAction.search,
      noBorder: noBorder,
      isRequired: isRequired,
      readOnly: readOnly ?? false,
      label: label,
      isDark: false,
      contentPaddingH: contentPaddingH,
      lines: lines ?? 1,
      fontSize: fontSize,
      radius: radius,
      onChange: onChange,
      suffixIconData: suffixIconData,
      validateFunc: validateFunc,
      suffixText: suffixText,
      formatter: formatter,
      type: TextInputType.text,
      isDarkBackground: isDarkBackground,
      controller: controller,
      focusNode: focusNode,
      suffixData: suffixDataWidget ??
          (onFilterTap != null
              ? Padding(
                  padding: EdgeInsets.all(kFormPaddingAllSmall.w),
                  child: Material(
                    elevation: 2,
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(kFormRadius),
                    ),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kFormRadius),
                      ),
                      onTap: onFilterTap,
                      child: Padding(
                        padding: EdgeInsets.all(kFormPaddingAllSmall.w),
                        child: Icon(
                          Icons.tune,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ))
              : const SizedBox()),
      onSubmit: onSubmit,
    );
  }
}
