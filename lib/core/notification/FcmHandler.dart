import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/logger.dart';
import 'NotificationType.dart';
import 'NotificationUtils.dart';
import 'push_notification_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class FcmHandler extends StatefulWidget {
  final Widget _child;
  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  _FcmHandlerState createState() => _FcmHandlerState();

  const FcmHandler({
    Key? key,
    required Widget child,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _child = child,
        _navigatorKey = navigatorKey,
        super(key: key);
}

class _FcmHandlerState extends State<FcmHandler> {
  static const _tag = 'FcmHandler';

  static bool initialized = false;

  static const IOSNotificationDetails iosLiquidChannel = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "default");

  Future selectNotification(String? payload) async {
    if (payload != null) {
      log(_tag, 'notification payload android: $payload');
      setupNotificationClickAction(payload, widget._navigatorKey);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      log(_tag, 'notification payload android: $payload');
      setupNotificationClickAction(payload, widget._navigatorKey);
    }
  }

  @override
  void initState() {
    super.initState();

    if (!initialized) initializeFcm();
  }

  @override
  Widget build(BuildContext context) {
    return widget._child;
  }

  Future<void> initializeFcm() async {
    if (!initialized) {
      // initialize Firebase
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      // initialize Firebase
      await Firebase.initializeApp();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
              onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification,
      );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      /// NEW
      // assign channel (required after android 8)
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      ///init FirebaseMessaging
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        setupNotificationClickAction(
            json.encode(remoteMessage.data), widget._navigatorKey);
      }

      log(_tag, "Requesting FCM token...");

      _getToken();

      /// onMessage
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log(_tag,
            'FCM foreground message: ${message.data}\n notification - ${message.notification?.title ?? ''}');
        log(_tag,
            'FCM foreground message: ${message.data}\n <notification - ${message.notification?.body}>');
        log(_tag,
            'FCM foreground message: ${message.data}\n <notification image- ${message.notification?.android?.imageUrl}>');
        log(_tag,
            'FCM foreground message: ${message.data}\n <notification image- ${message.notification?.apple?.imageUrl}>');

        StyleInformation? styleInformation;
        if (message.notification?.android?.imageUrl != null) {
          final bigPicturePath = await NotificationUtils.downloadAndSaveImage(
              message.notification!.android!.imageUrl!, "fileName");
          styleInformation =
              BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath));
        } else if (message.notification?.apple?.imageUrl != null) {
          final bigPicturePath = await NotificationUtils.downloadAndSaveImage(
              message.notification!.apple!.imageUrl!, "fileName");
          styleInformation =
              BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath));
        }

        if (Platform.isAndroid) {
          flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title,
            message.notification?.body,

            // message.data['title'],
            // message.data['body'],
            NotificationUtils(styleInformation: styleInformation)
                .getNotificationSpecifics(),
            payload: json.encode(message.data),
          );
        } else if (Platform.isIOS) {
          flutterLocalNotificationsPlugin.show(
            0,
            // message.data['title'],
            // message.data['body'],
            message.notification?.title,
            message.notification?.body,
            const NotificationDetails(iOS: iosLiquidChannel),
            payload: json.encode(message.data),
          );
        }
      });

      ///onMessageOpenedApp
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log(_tag, 'onMessageOpenedApp Data:${message.data}');
        setupNotificationClickAction(
            json.encode(message.data), widget._navigatorKey);
      });
    }
  }

  _getToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      log(_tag, "FCM token: $token");

      // GlobalService().setFcmToken(token);

      initialized = true;

      // post token to server
      // var response = await SettingsRepository().postFcmToken(token);
      // log("FCM Token sent to server: ${response.toJson().toString()}");
    } catch (e) {
      log(_tag, "FCM token error: $e");
    }
  }

  static void setupNotificationClickAction(
      String payload, GlobalKey<NavigatorState>? navigatorKey) {
    // handle firebase and local notification clicks here
    log(_tag, 'NOTIFICATIONS, ${payload.toString()}');

    FCMNotificationModel model = notificationModelFromJson(payload);

    // log(_tag,'NOTIFICATIONS, ${data.toString()}');
    // String? itemType = data.type;
    // int? itemId = data.referenceId;

    if (model != null) {
      NotificationHelper.notificationNav(model, navigatorKey: navigatorKey);
    }
  }

  void openDownloadedFile(String path) async {
    // final _result = await OpenFile.open(path);
    // print('${_result.message} >> ${_result.type.index}');

    // if (_result.type.index != 0) {
    //   showCustomSnackBar( _result.message,context);
    // }
  }
}
