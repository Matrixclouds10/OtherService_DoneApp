//{
// "id": 1,
// "name": "Cairo",
// "city_id": 1
//}

class RegionModel {
  int? id;
  String? name;
  int? cityId;

  RegionModel({
    this.id,
    this.name,
    this.cityId,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as int?,
      cityId: json['city_id'] as int?,
      name: json['name'] as String?,
    );
  }
}
