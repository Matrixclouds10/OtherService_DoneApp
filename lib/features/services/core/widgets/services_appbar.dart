import 'package:flutter/material.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/resources/text_styles.dart';

class ServicesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? titleColor;
  final bool isBackButtonExist;
  final Color? backBackgroundColor;
  final VoidCallback? onBackPress;
  // final IconData? icon;
  final bool showIcon;
  final Widget? titleWidget;
  final Widget? leading;
  final double? height;
  final Color? color;
  final Widget? flexibleSpace;

  final List<Widget>? actions;
  final Widget? logo;
  final bool isCenterTitle;
  final Widget? bottomWidget;
  final double? bottomSize;
  final Color? bottomColor;
  final Widget? centerLogo;
  final IconData? iconBack;

  const ServicesAppBar(
      {Key? key,
      this.title,
      this.titleWidget,
      this.centerLogo,
      this.titleColor,
      this.backBackgroundColor,
      this.isBackButtonExist = true,
      this.isCenterTitle = false,
      this.showIcon = false,
      // this.icon,
      this.bottomWidget,
      this.bottomSize,
      this.leading,
      this.bottomColor,
      this.height,
      this.flexibleSpace,
      this.logo,
      this.color,
      this.actions,
      this.onBackPress,
      this.iconBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(((height ?? 60) - (bottomSize ?? 0)).h),
      child: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).backgroundColor,
        title: titleWidget ??
            (title != null
                ? Text(title ?? '',
                    style: const TextStyle()
                        .titleStyle(fontSize: 16)
                        .boldStyle()
                        .customColor(titleColor ?? Colors.black))
                : centerLogo ?? const SizedBox.shrink()),
        centerTitle: isCenterTitle,
        leading: leading ??
            (isBackButtonExist
                ? GestureDetector(
                    onTap: onBackPress ?? () => Navigator.pop(context),
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: backBackgroundColor),
                        margin: const EdgeInsets.all(kFormPaddingAllSmall),
                        child: Icon(iconBack ?? Icons.arrow_back,
                            color: titleColor ?? Colors.black)))
                // ? IconButton(color: backBackgroundColor,icon: Icon(iconBack ?? Icons.arrow_back, color:titleColor?? Colors.black), onPressed: onBackPress ?? () => Navigator.pop(context),)
                : const SizedBox()),
        elevation: 0.0,
        leadingWidth: isBackButtonExist ? null : 0,

        bottomOpacity: 0.0,
        flexibleSpace: flexibleSpace ??
            Container(
              decoration: BoxDecoration(color: color ?? Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: logo ?? const SizedBox()),
                  if (bottomWidget != null)
                    Column(
                      children: [
                        Container(
                          height: (bottomSize ?? 20).h,
                          width: deviceWidth,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(kFormRadius),
                                topRight: Radius.circular(kFormRadius)),
                          ),
                          child: bottomWidget ?? const SizedBox.expand(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, height ?? 60);
}
