import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/services/network/network_client.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/data/app_urls/app_url.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/data/app_urls/provider_endpoints_url.dart';

class NotificationsFCM {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationsFCM() {
    configLocalNotification();
    registerNotification();
    _createNotificationChannel("682", "Done", "Done");
  }

  void registerNotification() async {
    kEcho('FCM registerNotification');
    await firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      message.data.forEach((key, value) {
        kEcho('fcm message $key -> $value');
      });
      RemoteNotification notification = message.notification!;
      Map<String, dynamic> data = message.data;
      // AndroidNotification android = message.notification!.android!;

      showNotification('${notification.title}', '${notification.body}', data);
    });
    firebaseMessaging.subscribeToTopic("682");
    firebaseMessaging.getToken().then((token) {
      kEcho('FCM registerNotification token $token');
      saveFCM(token!);
    });
  }

  // void _handleMessage(RemoteMessage message) {
  //   kEcho('_handleMessage');
  //   String? navigator = message.data['navigator'];
  //   String? id = message.data['id'];
  //   if (navigator == 'product' && id != null) {
  //     try {
  //       int idAsInt = int.parse(id);
  //       ProductModel productModel = ProductModel(productId: idAsInt, price: 0);

  //       Get.toNamed(
  //         Routes.PRODUCT,
  //         arguments: productModel,
  //         parameters: {"wholesalerId": '1'},
  //       );
  //     } catch (e) {
  //       if (kDebugMode) showSnackBar(title: Strings().notification, message: '$e');
  //     }
  //   }
  // }

  void configLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future<void> _createNotificationChannel(String id, String name, String description) async {
    kEcho('create channel');
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = AndroidNotificationChannel(
      id,
      name,
    );
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);
  }

  void showNotification(String title, String message, Map<String, dynamic> payLoad) async {
    kEcho('FCM showNotification message $message');
    kEcho('FCM showNotification payLoad $payLoad');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '682',
      'Done',
      playSound: true,
      enableVibration: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      message,
      platformChannelSpecifics,
      payload: payLoad.toString(),
    );
  }

  void saveFCM(String fcm) async {
    AppPrefs prefs = getIt<AppPrefs>();
    bool isTypeProduct = prefs.get(PrefKeys.isTypeProvider, defaultValue: false);
    String url = isTypeProduct ? AppURLProvider.updateFcm : AppURL.kUpdateFCMTokenURI;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {
      'fcm_token': fcm,
    };
    NetworkClient networkClient = getIt<NetworkClient>();
    await networkClient(url: url, data: data, type: type);
  }

  void selectNotification(String? payload) async {
    AppPrefs prefs = getIt<AppPrefs>();
    bool isTypeProduct = prefs.get(PrefKeys.isTypeProvider, defaultValue: false);
    if (isTypeProduct) {
      NavigationService.push(RoutesProvider.providerNotifications);
    } else {
      NavigationService.push(RoutesServices.servicesNotifications);
    }
  }
}
