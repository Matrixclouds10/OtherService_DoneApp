import 'package:flutter/material.dart';

import 'package:weltweit/app.dart';
import 'push_notification_model.dart';

class NotificationHelper {
  // defined from remote
  static const String kRequest = 'order';
  static const String kImage = 'image';
  static const String kFileDownloaded = 'download';

  // local notification
  // static const int FILE_DOWNLOADED = 1001;

  static notificationNav(FCMNotificationModel model,
      {BuildContext? context, GlobalKey<NavigatorState>? navigatorKey}) {
    // log('notificationNav'," start with type is :$type, and id is : $id");
    if (appContext == null && navigatorKey == null) {
      return;
    }
    if (model.type == kImage) {
      // NavigationService.push(Routes.imageScreen,arguments: {'imageUrl':model.link});
    } else if (model.type == kRequest) {
      // NavigationService.push(Routes.requestDetailsScreen,arguments: {'requestId':model.requestId});
    }
  }
}
