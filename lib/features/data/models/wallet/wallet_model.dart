class WalletModel {
  final int? id;
  final int? providerId;
  final double? amount;
  final String? message;

  WalletModel({
    this.id,
    this.providerId,
    this.amount,
    this.message,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        id: json["id"],
        providerId: json["provider_id"],
        amount: json["amount"] == null ? 0.0 : json["amount"].toDouble(),
        message: json["message"],
      );
}
