// {
//     "code": 200,
//     "message": "Data Updated Successfully",
//     "data": {
//         "provider_id": 766,
//         "subscription_id": "7",
//         "starts_at": "2023-08-02",
//         "ends_at": "2024-02-02",
//         "status": "pending",
//         "payment_method": "credit",
//         "payment_id": 140494896,
//         "payment_status": "pending",
//         "kiosk_bill_reference": null,
//         "updated_at": "2023-08-02T10:55:16.000000Z",
//         "created_at": "2023-08-02T10:55:16.000000Z",
//         "id": 251
//     },
//     "payment_data": {
//         "redirect_url": "https://accept.paymobsolutions.com/api/acceptance/iframes/772275?payment_token=ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SjFjMlZ5WDJsa0lqb3hORGszT0RNMUxDSmhiVzkxYm5SZlkyVnVkSE1pT2pFd01EQXdMQ0pqZFhKeVpXNWplU0k2SWtWSFVDSXNJbWx1ZEdWbmNtRjBhVzl1WDJsa0lqbzBNREE1TkRrMkxDSnZjbVJsY2w5cFpDSTZNVFF3TkRrME9EazJMQ0ppYVd4c2FXNW5YMlJoZEdFaU9uc2labWx5YzNSZmJtRnRaU0k2SWtSbGJXOGlMQ0pzWVhOMFgyNWhiV1VpT2lKRVpXMXZJaXdpYzNSeVpXVjBJam9pVGtFaUxDSmlkV2xzWkdsdVp5STZJazVCSWl3aVpteHZiM0lpT2lKT1FTSXNJbUZ3WVhKMGJXVnVkQ0k2SWs1Qklpd2lZMmwwZVNJNklrNUJJaXdpYzNSaGRHVWlPaUpPUVNJc0ltTnZkVzUwY25raU9pSk9RU0lzSW1WdFlXbHNJam9pWkdWMlpXeHZjR1Z5TVRKQVoyMWhhV3d1WTI5dElpd2ljR2h2Ym1WZmJuVnRZbVZ5SWpvaU1UQXhNREV3TVRBeE1pSXNJbkJ2YzNSaGJGOWpiMlJsSWpvaVRrRWlMQ0psZUhSeVlWOWtaWE5qY21sd2RHbHZiaUk2SWs1QkluMHNJbXh2WTJ0ZmIzSmtaWEpmZDJobGJsOXdZV2xrSWpwbVlXeHpaU3dpWlhoMGNtRWlPbnQ5TENKemFXNW5iR1ZmY0dGNWJXVnVkRjloZEhSbGJYQjBJanBtWVd4elpTd2laWGh3SWpveE5qa3hNREE1TnpFMkxDSndiV3RmYVhBaU9pSTJOaTR5T1M0eE5ETXVNakkwSW4wLk5tRnFzX0M1Q2lWV2tZOFBwUG93aG9nRnZtUWcyQ2hJUHBOSXlTbE1neklEXzNXLU5fRDAydG82NlFRUDl5UkhBNEtFUFlsR3UxM0VBQmVHY3EtWGd3",
//         "kiosk_bill_reference": null
//     }
// }

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

  int? providerId;
  String? subscriptionId;
  DateTime? startsAt;
  DateTime? endsAt;
  String? status;
  String? paymentMethod;
  int? paymentId;
  String? paymentStatus;
  String? kioskBillReference;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
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
