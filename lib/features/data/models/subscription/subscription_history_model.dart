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
    required this.paymentId,
    required this.paymentStatus,
    required this.kioskBillReference,
  });

  final int? id;
  final int? providerId;
  final int? subscriptionId;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? status;
  final String? paymentMethod;
  final int? paymentId;
  final String? paymentStatus;
  final String? kioskBillReference;
  final SubscriptionModel? subscription;

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) => SubscriptionHistoryModel(
        id: json["id"],
        providerId: json["provider_id"],
        subscriptionId: json["subscription_id"],
        startsAt: DateTime.tryParse(json["starts_at"]),
        endsAt: DateTime.tryParse(json["ends_at"]),
        status: json["status"],
        paymentMethod: json["payment_method"],
        paymentId: json["payment_id"],
        paymentStatus: json["payment_status"],
        kioskBillReference: json["kiosk_bill_reference"]==null?null :'${json["kiosk_bill_reference"]}',
        subscription: json["subscription"] == null ? null : SubscriptionModel.fromJson(json["subscription"]),
      );
}
