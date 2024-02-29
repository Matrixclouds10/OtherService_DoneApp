class SubscriptionModel {
  SubscriptionModel({
    required this.id,
    required this.name,
    required this.period,
    required this.price,
    required this.countryId,
  });

  dynamic id;
  dynamic name;
  dynamic period;
  dynamic price;
  dynamic countryId;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json["id"],
        name: json["name"],
        period: json["period"],
        price: json["price"],
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "period": period,
        "price": price,
        "country_id": countryId,
      };
}
