import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weltweit/bloc.dart';
import 'package:weltweit/features/injection.dart' as services_injection;

import 'app.dart';
import 'base_injection.dart' as injection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // print('${record.level.name}: ${record.time}: ${record.message}');
  });
  // for the responsive service to work (I don't know the reason until now)
  await Future.delayed(const Duration(milliseconds: 300));
  await EasyLocalization.ensureInitialized();

  // initialize Firebase
  await Firebase.initializeApp();

  await injection.init();
  await services_injection.init();
  runApp(
    GenerateMultiBloc(
      child: EasyLocalization(
          supportedLocales: supportedLocales,
          path: 'assets/strings',
          fallbackLocale: supportedLocales[0],
          saveLocale: true,
          useOnlyLangCode: true,
          startLocale: supportedLocales[0],
          child: const MyApp()),
    ),
  );
}

final supportedLocales = <Locale>[
  const Locale('ar'),
  const Locale('en'),
];
