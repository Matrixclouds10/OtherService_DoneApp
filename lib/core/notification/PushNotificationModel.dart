// To parse this JSON data, do
//
//     final pushNotificationModel = pushNotificationModelFromJson(jsonString);

import 'dart:convert';

PushNotificationModel pusssssshNotificationModelFromJson(String str) =>
    PushNotificationModel.fromJson(json.decode(str));

String pushNotificationModelToJson(PushNotificationModel data) =>
    json.encode(data.toJson());

class PushNotificationModel {
  PushNotificationModel({
    this.notificationForeground,
    this.title,
    this.body,
    this.itemType,
    this.itemId,
    this.bigPicture,
  });

  String? notificationForeground;
  String? title;
  String? body;
  String? itemType;
  String? itemId;
  String? bigPicture;

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) =>
      PushNotificationModel(
        notificationForeground: json["notification_foreground"],
        title: json["title"],
        body: json["body"],
        itemType: json["itemType"],
        itemId: json["itemId"],
        bigPicture: json["bigPicture"],
      );

  Map<String, dynamic> toJson() => {
        "notification_foreground": notificationForeground,
        "title": title,
        "body": body,
        "itemType": itemType,
        "itemId": itemId,
        "bigPicture": bigPicture,
      };

  @override
  String toString() {
    return 'PushNotificationModel{notificationForeground: $notificationForeground, title: $title, body: $body, itemType: $itemType, itemId: $itemId, bigPicture: $bigPicture}';
  }
}
