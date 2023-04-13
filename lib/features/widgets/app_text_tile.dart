import 'package:flutter/material.dart';

class AppTextTile extends StatelessWidget {
  final Widget title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final Function? onTap;
  final bool isTitleExpanded;

  const AppTextTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.trailing,
    this.leading,
    this.onTap,
    this.isTitleExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: leading),
            SizedBox(width: 8),
          ],
          if (isTitleExpanded) Expanded(child: title),
          if (!isTitleExpanded) title,
          if (trailing != null) ...[
            SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
