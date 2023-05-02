import 'address_item_model.dart';

class AddressData {
  AddressItemModel? home;
  AddressItemModel? work;
  List<AddressItemModel>? favorites;

  AddressData({this.home, this.work, this.favorites});

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        home: json['home'] == null
            ? null
            : AddressItemModel.fromJson(json['home'] as Map<String, dynamic>),
        work: json['work'] == null
            ? null
            : AddressItemModel.fromJson(json['work'] as Map<String, dynamic>),
        favorites: (json['favorites'] as List<dynamic>?)
            ?.map((e) => AddressItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'home': home?.toJson(),
        'work': work?.toJson(),
        'favorites': favorites?.map((e) => e.toJson()).toList(),
      };
}
