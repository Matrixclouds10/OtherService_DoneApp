class ChatModel {
  int id;
  int serviceOrderId;
  int clientId;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.serviceOrderId,
    required this.clientId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        serviceOrderId: json["service_order_id"],
        clientId: json["client_id"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_order_id": serviceOrderId,
        "client_id": clientId,
        "message": message,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
