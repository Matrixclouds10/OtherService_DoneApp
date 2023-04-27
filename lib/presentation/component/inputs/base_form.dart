import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/text_styles.dart';
import 'package:weltweit/presentation/component/inputs/expaned_form_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/resources/font_manager.dart';
import '../../../core/resources/values_manager.dart';
import '../../../generated/locale_keys.g.dart';
import '../spaces.dart';
import 'orientation_view.dart';

class CustomTextField extends StatefulWidget {
  final String? _suffixText;
  final String? _hint;
  final String? _defaultValue;
  final String? _label;
  final bool _isHorizontal;

  final bool _enable;
  final bool _isDark;
  final bool _isDarkBackground;
  final bool _autoValidate;
  final bool _readOnly;
  final bool _obscureText;
  final bool _noBorder;
  final bool _isRequired;
  final bool _autofocus;

  final int? _maxLength;
  final int? _lines;

  final double? _fontSize;
  final double? _radius;
  final double? _contentPaddingH;

  final List<TextInputFormatter>? _formatter;

  final Color? _prefixIconColor;
  final Color? _background;

  final IconData? _prefixIcon;
  final IconData? _suffixIconData;

  final Widget? _suffixData;
  final Widget? _prefixWidget;
  final Widget? _icon;

  final VoidCallback? _onTap;
  final ValueChanged<String>? _onChange;
  final ValueChanged<String>? _onSaved;
  final Function? _validateFunc;
  final Function? _onSubmit;

  final TextAlign? _textAlign;
  final TextInputType _type;
  final TextEditingController? _controller;
  final TextInputAction? _textInputAction;
  final FocusNode? _focusNode;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

  const CustomTextField({
    super.key,
    String? suffixText,
    String? hint,
    String? defaultValue,
    String? label,
    bool autoValidate = false,
    bool isDarkBackground = false,
    bool obscureText = false,
    bool readOnly = false,
    bool isHorizontal = false,
    bool enable = true,
    bool isDark = false,
    bool noBorder = false,
    bool isRequired = true,
    bool autofocus = false,
    int? maxLength,
    int? lines = 1,
    double? contentPaddingH = 16,
    double? fontSize = 14,
    double? radius = 15,
    List<TextInputFormatter>? formatter,
    Color? prefixIconColor,
    Color? background,
    IconData? prefixIcon,
    IconData? suffixIconData,
    Widget? suffixData,
    Widget? prefixWidget,
    Widget? icon,
    VoidCallback? onTap,
    ValueChanged<String>? onChange,
    ValueChanged<String>? onSaved,
    Function? validateFunc,
    Function? onSubmit,
    TextAlign? textAlign,
    TextInputType type = TextInputType.text,
    TextEditingController? controller,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  })  : _suffixText = suffixText,
        _hint = hint,
        _defaultValue = defaultValue,
        _label = label,
        _isHorizontal = isHorizontal,
        _enable = enable,
        _isDark = isDark,
        _isDarkBackground = isDarkBackground,
        _autoValidate = autoValidate,
        _readOnly = readOnly,
        _obscureText = obscureText,
        _noBorder = noBorder,
        _isRequired = isRequired,
        _autofocus = autofocus,
        _maxLength = maxLength,
        _lines = lines,
        _fontSize = fontSize,
        _radius = radius,
        _contentPaddingH = contentPaddingH,
        _formatter = formatter,
        _prefixIconColor = prefixIconColor,
        _background = background,
        _prefixIcon = prefixIcon,
        _suffixIconData = suffixIconData,
        _suffixData = suffixData,
        _prefixWidget = prefixWidget,
        _icon = icon,
        _onTap = onTap,
        _onChange = onChange,
        _onSaved = onSaved,
        _validateFunc = validateFunc,
        _onSubmit = onSubmit,
        _textAlign = textAlign,
        _type = type,
        _controller = controller,
        _textInputAction = textInputAction,
        _focusNode = focusNode;
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    if (widget._defaultValue != null && widget._controller != null) {
      widget._controller!.text = widget._defaultValue!;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    // if (widget._error == '') {
    //   widget._error = null;
    // }
    return GestureDetector(
      onTap: widget._onTap,
      child: OrientationView(
        isHorizontal: widget._isHorizontal,
        children: [
          if (widget._isHorizontal) ...[
            CircleAvatar(radius: 4.r, backgroundColor: widget._isDark ? Theme.of(context).cardColor : Theme.of(context).hintColor),
            HorizontalSpace(8.h),
            if (widget._label != null) ...[
              Expanded(
                  flex: 2,
                  child: Text(
                    widget._label!,
                    style: const TextStyle().regularStyle().customColor(widget._isDark ? Theme.of(context).cardColor : Theme.of(context).hintColor),
                  )),
            ]
          ],

          // if (!widget._isHorizontal && widget._label != null) ...[
          //   Text(widget._label!, style: const TextStyle().regularStyle(fontSize: 16).boldStyle().customColor( widget._isDark?Theme.of(context).cardColor:Colors.black),),
          //   const VerticalSpace(kFormPaddingAllSmall,),
          // ],

          if (widget._isHorizontal) HorizontalSpace(16.w),
          ExpandedHelperView(
            isExpanded: widget._isHorizontal,
            child: TextFormField(
              cursorColor: widget._isDark ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
              readOnly: widget._readOnly,
              textInputAction: widget._textInputAction,
              maxLength: widget._maxLength,
              focusNode: widget._focusNode,
              autofocus: widget._autofocus,
              obscureText: widget._obscureText,
              onTap: widget._onTap,
              controller: widget._controller,
              textAlign: widget._textAlign ?? TextAlign.start,
              autovalidateMode: widget._autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
              style: TextStyle(
                color: widget._isDark ? Theme.of(context).cardColor : Colors.black,
                fontSize: 14.sp,
                fontFamily: FontConstants.fontFamily,
              ),
              decoration: InputDecoration(

                  // border: widget._noBorder ? InputBorder.none : Theme.of(context).inputDecorationTheme.border,
                  // disabledBorder: widget._noBorder ? InputBorder.none : Theme.of(context).inputDecorationTheme.disabledBorder,
                  // focusedBorder: widget._noBorder ? InputBorder.none :  Theme.of(context).inputDecorationTheme.focusedBorder,
                  // errorBorder: widget._noBorder ? InputBorder.none :Theme.of(context).inputDecorationTheme.errorBorder,

                  border: widget._noBorder ? InputBorder.none : Theme.of(context).inputDecorationTheme.border,
                  disabledBorder: widget._noBorder ? InputBorder.none : Theme.of(context).inputDecorationTheme.disabledBorder,
                  focusedBorder: widget._noBorder ? InputBorder.none : Theme.of(context).inputDecorationTheme.focusedBorder,
                  errorBorder: widget._noBorder ? InputBorder.none : Theme.of(context).inputDecorationTheme.errorBorder,
                  enabledBorder: widget._noBorder ? InputBorder.none : Theme.of(context).inputDecorationTheme.enabledBorder,
                  errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(color: widget._isDark ? Theme.of(context).highlightColor : Theme.of(context).hintColor),
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle?.copyWith(color: widget._isDark ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyMedium?.color),
                  suffixStyle: Theme.of(context).inputDecorationTheme.suffixStyle,
                  hintText: widget._hint,
                  labelText: widget._label,
                  filled: true,
                  fillColor: Colors.white,
                  counterStyle: TextStyle(color: Theme.of(context).primaryColor),
                  suffixText: widget._suffixText,
                  // suffixIcon: widget._icon!= null ?Container(width: 50,alignment: Alignment.center,child: widget._icon):(widget._suffixData ?? (widget._suffixIconData == null ? null : Icon(widget._suffixIconData, color:widget._isDark?Theme.of(context).cardColor:Theme.of(context).primaryColor,))),
                  suffixIcon: widget._suffixData != null
                      ? Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: widget._suffixData,
                        )
                      : (widget._suffixData ??
                          (widget._suffixIconData == null
                              ? null
                              : Icon(
                                  widget._suffixIconData,
                                  color: Theme.of(context).primaryColor,
                                ))),

                  // suffixStyle:  const TextStyle(
                  //   color:grayScaleColor,
                  //   fontSize: 12,
                  //   fontWeight: FontWeight.normal,
                  // ),
                  prefixIcon: widget._prefixWidget ??
                      (widget._prefixIcon == null
                          ? null
                          : Icon(
                              widget._prefixIcon,
                              size: 24,
                              color: widget._prefixIconColor ?? (widget._isDark ? Theme.of(context).cardColor : Colors.black),
                            )),
                  contentPadding: const EdgeInsets.symmetric(horizontal: kScreenPaddingNormal, vertical: 10)),
              keyboardType: widget._type,
              validator: (value) {
                if (widget._validateFunc != null && widget._isRequired) {
                  return widget._validateFunc!(value);
                } else if ((value == null || value.isEmpty) && widget._isRequired) {
                  return tr(LocaleKeys.msgFormFieldRequired);
                }
                return null;
              },
              enabled: widget._enable,
              maxLines: widget._lines,
              inputFormatters: widget._formatter,
              onChanged: (String newValue) {
                if (widget._onChange != null) return widget._onChange!(newValue);
                return;
              },
              onFieldSubmitted: (String newValue) {
                if (widget._onSubmit != null) return widget._onSubmit!(newValue);
                return;
              },
              onSaved: (String? newValue) {
                if (widget._onSaved != null) return widget._onSaved!(newValue ?? '');
                return;
              },
            ),
          ),
        ],
      ),
    );
  }
}
