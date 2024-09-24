import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:weltweit/bloc.dart';
import 'package:weltweit/features/injection.dart' as services_injection;

import 'app.dart';
import 'base_injection.dart' as injection;
import 'core/notification/FcmHandler.dart';
import 'core/notification/notification_service.dart';
import 'firebase_options.dart';

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await injection.init();
  await services_injection.init();
  // NotificationService d =NotificationService();
  // d.init();
  //done.app2023@gmail.com
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn = 'https://b80efbe170784258b7c288ef147e4eb9@o4505269393489920.ingest.sentry.io/4505269463416832';
  //     options.tracesSampleRate = 1.0;
  //   },
  //   appRunner: () => runZonedGuarded(() {
  // 24/09/2024
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
              child:
              DevicePreview(
                  enabled: false,
                  builder: (context) => const MyApp()
              // const MyApp()
          ),
        )));
    // }, (error, stack) {
    //   if (!kDebugMode) Sentry.captureException(error, stackTrace: stack);
    // }),
  // );
}

final supportedLocales = <Locale>[
  const Locale('ar'),
  const Locale('en'),
];
