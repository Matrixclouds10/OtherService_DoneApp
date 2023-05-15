class ChatModel {
  int id;
  int serviceOrderId;
  int providerId;
  String message;
  String? image;
  String? lat;
  String? lng;
  DateTime createdAt;
  DateTime updatedAt;
  ClientModel? client;
  ChatModel({
    required this.id,
    required this.serviceOrderId,
    required this.providerId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.lat,
    required this.lng,
    this.client,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        serviceOrderId: json["service_order_id"],
        providerId: json["provider_id"] ??0,
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        client: json["client"] != null ? ClientModel.fromJson(json["client"]) : null,
        image: json["image"],
        lat: "${json["lat"]}",
        lng: "${json["lng"]}",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_order_id": serviceOrderId,
        "provider_id": providerId,
        "message": message,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ClientModel {
  int id;

  ClientModel({
    required this.id,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
