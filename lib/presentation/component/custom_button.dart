import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';
import '../../core/resources/text_styles.dart';
import '../../core/resources/values_manager.dart';
import '../component/component.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback _onTap;
  final Widget? _child;
  final String? _title;
  final Color? _color;
  final Color? _textColor;
  final double? _width;
  final double? _height;
  final double? _fontSize;
  final bool _isRounded;
  final bool _isOutlined;
  final bool _widerPadding;
  final bool _loading;
  final bool _expanded;
  final double _radius;

  const CustomButton({
    super.key,
    required VoidCallback onTap,
    Widget? child,
    String? title,
    Color? color,
    Color? textColor,
    double? width,
    double? fontSize,
    double? height,
    double radius = kFormRadiusLarge,
    bool isRounded = true,
    bool isOutlined = false,
    bool widerPadding = false,
    bool loading = false,
    bool expanded = true,
  })  : _onTap = onTap,
        _child = child,
        _title = title,
        _expanded = expanded,
        _color = color,
        _textColor = textColor,
        _width = width,
        _radius = radius,
        _fontSize = fontSize,
        _height = height,
        _isRounded = isRounded,
        _isOutlined = isOutlined,
        _widerPadding = widerPadding,
        _loading = loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _expanded ? (_width ?? deviceWidth) : null,
      height: (_height ?? 46).h,
      child: TapEffect(
        isClickable: !_loading,
        onClick: _loading ? null : _onTap,
        child: MaterialButton(
          color: _isOutlined
              ? Colors.transparent
              : (_color ?? Theme.of(context).primaryColor),
          highlightElevation: 0,
          onPressed: _loading ? () {} : _onTap,
          padding: !_widerPadding
              ? EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w)
              : EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          elevation: 0,
          shape: _isRounded
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius.r),
                  side: BorderSide(
                      color: _color ?? Theme.of(context).primaryColor,
                      width: 1.5.w))
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius.r),
                  side: BorderSide(
                      color: _color ?? Theme.of(context).primaryColor,
                      width: 1.5.w)),
          child: _loading
              ? CustomLoadingSpinner(
                  size: (_height ?? 20).h, color: Theme.of(context).cardColor)
              : _title != null
                  ? Center(
                      child: Text(
                        _title!,
                        style: const TextStyle()
                            .regularStyle(fontSize: _fontSize ?? 14)
                            .customColor(_textColor ?? Colors.white),
                      ),
                    )
                  : _child ?? const SizedBox(),
        ),
      ),
    );
  }
}
