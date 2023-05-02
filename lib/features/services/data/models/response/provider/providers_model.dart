import 'package:weltweit/features/services/data/models/response/services/service.dart';

class ProvidersModel {
  int? id;
  String? name;
  String? description;
  String? email;
  String? mobileNumber;
  String? countryCode;
  int? otpVerified;
  int? approved;
  dynamic lat;
  dynamic lng;
  String? image;
  dynamic distance;
  List<ServiceModel>? services;
  String? rateAvg;
  int? rateCount;
  bool isFavorite;
  bool isOnline;

  ProvidersModel({
    this.id,
    this.name,
    this.email,
    this.description,
    this.mobileNumber,
    this.countryCode,
    this.otpVerified,
    this.approved,
    this.lat,
    this.lng,
    this.image,
    this.distance,
    this.services,
    this.rateAvg,
    this.rateCount,
    this.isFavorite = false,
    this.isOnline = false,
  });

  factory ProvidersModel.fromJson(Map<String, dynamic> json) {
    return ProvidersModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      description: json['description'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      countryCode: json['country_code'] as String?,
      otpVerified: json['otp_verified'] as int?,
      approved: json['approved'] as int?,
      lat: json['lat'] as dynamic,
      lng: json['lng'] as dynamic,
      image: json['image'] as String?,
      distance: json['distance'] as dynamic,
      services: json['services']['data'] == null ? [] : json['services']['data'].map<ServiceModel>((e) => ServiceModel.fromJson(e)).toList(),
      rateAvg: json['rate_avg'] as String?,
      rateCount: json['rate_count'] as int?,
      isFavorite: "${json['is_fav']}".toLowerCase() == "true",
      isOnline: "${json['is_online']}".toLowerCase() == "yes",
    );
  }
}
