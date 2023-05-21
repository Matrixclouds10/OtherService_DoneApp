import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/utils/logger.dart';

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

_onLogoutPress(BuildContext context) async {
  await FirebaseMessaging.instance.deleteToken();
}
