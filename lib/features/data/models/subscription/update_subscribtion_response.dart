

class UpdateSubscribtionResponse {
  UpdateSubscribtionResponse({
    required this.providerId,
    required this.subscriptionId,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.paymentMethod,
    required this.paymentId,
    required this.paymentStatus,
    required this.kioskBillReference,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.paymentData,
  });

  dynamic providerId;
  String? subscriptionId;
  DateTime? startsAt;
  DateTime? endsAt;
  String? status;
  String? paymentMethod;
  dynamic paymentId;
  dynamic paymentStatus;
  String? kioskBillReference;
  DateTime? updatedAt;
  DateTime? createdAt;
  dynamic id;
  PaymentData? paymentData;

  factory UpdateSubscribtionResponse.fromJson(Map<String, dynamic> json) => UpdateSubscribtionResponse(
        providerId: json["provider_id"],
        subscriptionId:'${json["subscription_id"]}',
        startsAt: DateTime.tryParse(json["starts_at"]),
        endsAt: DateTime.tryParse(json["ends_at"]),
        status: json["status"],
        paymentMethod: json["payment_method"],
        paymentId: json["payment_id"],
        paymentStatus: json["payment_status"],
        kioskBillReference: json["kiosk_bill_reference"]==null?null :'${json["kiosk_bill_reference"]}',
        updatedAt: DateTime.tryParse(json["updated_at"]),
        createdAt: DateTime.tryParse(json["created_at"]),
        id: json["id"],
        paymentData: PaymentData.fromJson(json["payment_data"]),
      );
}

class PaymentData {
  PaymentData({
    required this.redirectUrl,
    required this.kioskBillReference,
  });

  String? redirectUrl;
  String? kioskBillReference;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        redirectUrl: json["redirect_url"],
        kioskBillReference: json["kiosk_bill_reference"] ==null?null:'${json["kiosk_bill_reference"]}',
      );
}
