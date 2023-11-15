
class PushFirebaseNotificationModel {
  PushFirebaseNotificationModel({
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

  factory PushFirebaseNotificationModel.fromJson(Map<String, dynamic> json) =>
      PushFirebaseNotificationModel(
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
