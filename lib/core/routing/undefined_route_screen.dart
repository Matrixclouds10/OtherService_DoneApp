import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class UndefinedRouteScreen extends StatelessWidget {
  const UndefinedRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          tr(LocaleKeys.noRouteFound),
          style: const TextStyle().titleStyle(),
        ),
      ),
    );
  }
}
