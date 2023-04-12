import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';

class AppBackButton extends StatelessWidget {
  final double padding;
  final Color color;
  final Function()? onTap;
  const AppBackButton({
    this.onTap,
    this.padding = 8,
    this.color = Colors.black,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => NavigationService.goBack(),
      child: Container(
        padding: EdgeInsets.all(padding),
        color: Colors.transparent,
        margin: EdgeInsets.all(kFormPaddingAllSmall),
        child: Icon(Icons.arrow_back, color: color),
      ),
    );
  }
}
