// {
//             "id": 1,
//             "name": "Cairo",
//             "country_id": 1
//         }

class CityModel {
  int? id;
  String? name;
  int? countryId;

  CityModel({
    this.id,
    this.name,
    this.countryId,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      countryId: json['country_id'] as int?,
    );
  }
}
