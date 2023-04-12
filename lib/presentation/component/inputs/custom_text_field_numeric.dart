import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base_form.dart';

class CustomTextFieldNumber extends StatelessWidget {
  final String? suffixText;
  final String? hint;
  final String? defaultValue;
  final String? label;
  final String? iconSVG;

  final bool readOnly;
  final bool autoValidate;
  final bool noBorder;
  final bool isRequired;
  final bool autofocus;
  final bool enable;

  final int? lines;
  final int? maxLength;

  final double? fontSize;
  final double? radius;
  final double? contentPaddingH;

  final List<TextInputFormatter>? formatter;

  final Widget? icon;
  final Widget? suffixData;

  final IconData? iconData;
  final IconData? suffixIconData;

  final Color? background;

  final VoidCallback? onTap;
  final ValueChanged<String>? onChange;
  final Function? validateFunc;
  final Function? onSubmit;

  final TextEditingController? controller;
  final TextInputAction? textInputAction;

  const CustomTextFieldNumber({
    Key? key,
    this.suffixText,
    this.hint,
    this.defaultValue,
    this.label,
    this.iconSVG,
    this.autoValidate = false,
    this.readOnly = false,
    this.noBorder = false,
    this.isRequired = true,
    this.autofocus = false,
    this.enable = true,
    this.lines,
    this.maxLength,
    this.fontSize,
    this.radius,
    this.contentPaddingH,
    this.formatter,
    this.icon,
    this.suffixData,
    this.iconData,
    this.suffixIconData,
    this.background,
    this.onTap,
    this.onChange,
    this.validateFunc,
    this.onSubmit,
    this.controller,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      background: background,
      prefixIcon: iconData,
      defaultValue: defaultValue,
      // prefixWidget:iconSVG==null?null: SizedBox(height: 20.r,width: 20.r,child: Center(child:SVGIcon(iconSVG!,color: Colors.black,)  )),

      hint: hint,
      icon: icon,
      onTap: onTap,
      autoValidate: autoValidate,
      autofocus: autofocus,
      readOnly: readOnly,
      maxLength: maxLength,
      enable: enable,
      noBorder: noBorder,
      isRequired: isRequired,
      label: label,
      contentPaddingH: contentPaddingH,
      lines: lines,
      fontSize: fontSize,
      radius: radius,
      onChange: onChange,
      suffixIconData: suffixIconData,
      suffixText: suffixText,
      formatter: formatter ?? [FilteringTextInputFormatter.digitsOnly],
      type: TextInputType.number,
      controller: controller,
      suffixData: suffixData,
      onSubmit: onSubmit,
      textInputAction: textInputAction,
      validateFunc: validateFunc ??
          (value) {
            int? v = int.tryParse(value);
            if (v == null) {
              return tr(LocaleKeys.msgFormFieldRequired);
            }
            if (validateFunc != null) return validateFunc!(value);
            return null;
          },
    );
  }
}
