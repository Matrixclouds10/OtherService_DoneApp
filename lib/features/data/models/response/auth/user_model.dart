import 'package:weltweit/features/data/models/response/country/country_model.dart';

class UserModel {
  int? id;
  String? name;
  String? isOnline;
  String? email;
  String? mobileNumber;
  String? token;
  int? approved;
  int? otpVerified;
  String? countryCode;
  String? image;
  String gender;
  String? desc;
  int? isCompany;
  CountryModel? countryModel;
  UserModel({
    this.id,
    this.name,
    this.isOnline,
    this.email,
    required this.gender,
    this.mobileNumber,
    this.token,
    this.approved,
    this.otpVerified,
    this.countryCode,
    this.image,
    this.desc,
    this.isCompany,
    this.countryModel,
  });

  bool isAvailable() {
    return '$isOnline'.toLowerCase() == "yes" || '$isOnline'.toLowerCase() == "on";
  }

  String getName() => name ?? "";
  String getMobileNumber() => mobileNumber ?? "";
  String getEmail() => email ?? "";
  String getGender() => gender;
  String getImage() => image ?? "";
  String getCountryCode() => countryCode ?? "";
  String getToken() => token ?? "";
  int getID() => id ?? 0;
  int getIsCompany() => isCompany ?? 0;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
        isCompany: json['is_company'] as int?,
        countryModel: json['country'] == null ? null : CountryModel.fromJson(json['country'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_online': isOnline,
        'email': email,
        'mobile_number': mobileNumber,
        'token': token,
        'approved': approved,
        'otp_verified': otpVerified,
        'country_code': countryCode,
        'image': image,
        'is_company': isCompany,
        'country_id': countryModel?.id,
      };
}
