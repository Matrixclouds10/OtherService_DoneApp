import 'dart:convert';

FCMNotificationModel notificationModelFromJson(String str) =>
    FCMNotificationModel.fromJson(json.decode(str));

String notificationModelToJson(FCMNotificationModel data) =>
    json.encode(data.toJson());

class FCMNotificationModel {
  FCMNotificationModel({
    this.requestId,
    this.status,
    this.type,
    this.link,
  });

  int? requestId;
  String? type;
  String? link;
  String? status;

  factory FCMNotificationModel.fromJson(Map<String, dynamic> json) =>
      FCMNotificationModel(
        requestId: int.tryParse(json["order_id"] ?? '0'),
        status: json["status"],
        type: json["type"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": requestId,
        "type": type,
        "link": link,
      };
}
