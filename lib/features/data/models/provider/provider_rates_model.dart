

class ProviderRateModel{
  String? clientName;
  String? clientImage;
  int? rate;
  String? comment;

  ProviderRateModel({
    this.clientName,
    this.clientImage,
    this.rate,
    this.comment,
  });

  factory ProviderRateModel.fromJson(Map<String, dynamic> json) {
    return ProviderRateModel(
      clientName: json['client_name'] as String?,
      clientImage: json['client_image'] as String?,
      rate: json['rate'] as int?,
      comment: json['comment'] as String?,
    );
  }
}