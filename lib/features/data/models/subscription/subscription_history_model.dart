
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';

class SubscriptionHistoryModel {
  SubscriptionHistoryModel({
    required this.id,
    required this.providerId,
    required this.subscriptionId,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.paymentMethod,
    required this.subscription,
  });

  final int id;
  final int providerId;
  final int subscriptionId;
  final DateTime startsAt;
  final DateTime endsAt;
  final String status;
  final String paymentMethod;
  final SubscriptionModel subscription;

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) => SubscriptionHistoryModel(
        id: json["id"],
        providerId: json["provider_id"],
        subscriptionId: json["subscription_id"],
        startsAt: DateTime.parse(json["starts_at"]),
        endsAt: DateTime.parse(json["ends_at"]),
        status: json["status"],
        paymentMethod: json["payment_method"],
        subscription: SubscriptionModel.fromJson(json["subscription"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "subscription_id": subscriptionId,
        "starts_at": startsAt.toIso8601String(),
        "ends_at": endsAt.toIso8601String(),
        "status": status,
        "payment_method": paymentMethod,
        "subscription": subscription.toJson(),
      };
}
