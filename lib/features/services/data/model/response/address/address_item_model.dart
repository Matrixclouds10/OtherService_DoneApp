class AddressItemModel {
  int? id;
  int? clientId;
  String? name;
  int? phone;
  String? address;
  int? regionId;
  String? regionName;
  String? active;
  String? lat;
  String? lng;
  String? addressType;

  AddressItemModel({
    this.id,
    this.clientId,
    this.name,
    this.phone,
    this.address,
    this.regionId,
    this.regionName,
    this.active,
    this.lat,
    this.lng,
    this.addressType,
  });

  factory AddressItemModel.fromJson(Map<String, dynamic> json) =>
      AddressItemModel(
        id: json['id'] as int?,
        clientId: json['client_id'] as int?,
        name: json['name'] as String?,
        phone: json['phone'] as int?,
        address: json['address'] as String?,
        regionId: json['region_id'] as int?,
        regionName: json['region_name'] as String?,
        active: json['active'] as String?,
        lat: json['lat'] as String?,
        lng: json['lng'] as String?,
        addressType: json['address_type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'client_id': clientId,
        'name': name,
        'phone': phone,
        'address': address,
        'region_id': regionId,
        'region_name': regionName,
        'active': active,
        'lat': lat,
        'lng': lng,
        'address_type': addressType,
      };
}
