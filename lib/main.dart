import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:weltweit/bloc.dart';
import 'package:weltweit/features/injection.dart' as services_injection;

import 'app.dart';
import 'data/injection.dart' as data_injection;
import 'injection.dart' as injection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://ca534611637c4c6f8526c840828a5d68@o4504111766962176.ingest.sentry.io/4505221184225280';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // print('${record.level.name}: ${record.time}: ${record.message}');
  });
  // for the responsive service to work (I don't know the reason until now)
  await Future.delayed(const Duration(milliseconds: 300));
  await EasyLocalization.ensureInitialized();

  // initialize Firebase
  await Firebase.initializeApp();

  await data_injection.init();
  await injection.init();

  await services_injection.init();

  runZonedGuarded(() {
    return runApp(
      GenerateMultiBloc(
        child: EasyLocalization(
            supportedLocales: supportedLocales,
            path: 'assets/strings',
            // if device language not supported
            fallbackLocale: supportedLocales[0],
            saveLocale: true,
            useOnlyLangCode: true,
            startLocale: supportedLocales[0],
            child: const MyApp()),
      ),
    );
  }, (error, stack) {
    if (!kDebugMode) Sentry.captureException(error, stackTrace: stack);
  });
}

final supportedLocales = <Locale>[
  const Locale('ar'),
  const Locale('en'),
];
