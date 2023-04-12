import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/domain/logger.dart';

import '../../../generated/locale_keys.g.dart';
import 'base/simple_dialogs.dart';

Future<bool?> showLogoutDialog(BuildContext context) async {
  logger.i('showLogoutDialog');
  return await showQuestionDialog(
    context,
    btnTextPositive: tr(LocaleKeys.no),
    btnTextNegative: tr(LocaleKeys.yes),
    question: tr(LocaleKeys.wantToSignOut),
    onNegativeClick: () => _onLogoutPress(context),
    onPositiveClick: () {},
  );
}

_onLogoutPress(BuildContext context) {}
