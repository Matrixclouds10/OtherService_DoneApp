import 'package:weltweit/features/data/models/response/country/country_model.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';

class UserModel {
  int? id;
  String? name;
  String? isOnline;
  String? email;
  String? mobileNumber;
  String? token;
  int? approved;
  int? otpVerified;
  int? countryId;
  String? countryCode;
  String? image;
  String gender;
  String? desc;
  int? isCompany;
  CountryModel? countryModel;
  double? wallet;
  SubscriptionModel? subscriptionModel;
  UserModel({
    this.id,
    this.name,
    this.isOnline,
    this.email,
    required this.gender,
    this.mobileNumber,
    this.countryId,
    this.token,
    this.approved,
    this.otpVerified,
    this.countryCode,
    this.image,
    this.desc,
    this.isCompany,
    this.countryModel,
    this.wallet,
    this.subscriptionModel,
  });

  bool isAvailable() {
    return '$isOnline'.toLowerCase() == "yes" || '$isOnline'.toLowerCase() == "on";
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? countryJson;
    if (json['country'] != null) {
      try {
        countryJson = json['country']['data'];
      } catch (e) {
        countryJson = json['country'];
      }
    }
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      isOnline: json['is_online'] as String?,
      email: json['email'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      token: json['token'] == null ? null : '${json['token']}',
      approved: json['approved'] as int?,
      otpVerified: json['otp_verified'] as int?,
      countryCode: json['country_code'] as String?,
      image: json['image'] as String?,
      gender: json['gender'] ?? "male",
      desc: json['description'] ?? "",
      countryId: 1,
      isCompany: json['is_company'] as int?,
      countryModel: countryJson != null ? CountryModel.fromJson(countryJson) : null,
      wallet: json['wallet'] as double?,
      subscriptionModel: json['subscription'] != null ? SubscriptionModel.fromJson(json['subscription']) : null,
    );
  }
}
