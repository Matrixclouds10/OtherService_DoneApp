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
  // int? isCompany;
  CountryModel? countryModel;
  String? wallet;
  int? countryId;
  CurrentSubscribtion? currentSubscription;
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
    // this.isCompany,
    this.countryModel,
    this.wallet,
    this.currentSubscription,
    this.countryId,
  });

  bool isAvailable() {
    return '$isOnline'.toLowerCase() == "yes" || '$isOnline'.toLowerCase() == "on";
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? countryJson;
    if (json['country'] != null) {
      if (json['country']['data'] != null) {
        countryJson = json['country']['data'];
      } else {
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
      // isCompany: json['is_company'] as int?,
      countryModel: countryJson != null ? CountryModel.fromJson(countryJson) : null,
      wallet: "${json['wallets']}",
      countryId: json['country_id'] == null ? null : int.tryParse('${json['country_id']}') ,
      currentSubscription: json['current_subscription'] != null ? CurrentSubscribtion.fromJson(json['current_subscription']) : null,
    );
  }
}

class CurrentSubscribtion {
  int? id;
  int? providerId;
  int? subscriptionId;
  String? startsAt;
  String? endsAt;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? paymentMethod;
  int? userId;

  CurrentSubscribtion({
    this.id,
    this.providerId,
    this.subscriptionId,
    this.startsAt,
    this.endsAt,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.paymentMethod,
    this.userId,
  });

  factory CurrentSubscribtion.fromJson(Map<String, dynamic> json) {
    return CurrentSubscribtion(
      id: json['id'] as int?,
      providerId: json['provider_id'] as int?,
      subscriptionId: json['subscription_id'] as int?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      status: json['status'] as String?,
      paymentMethod: json['payment_method'] as String?,
      userId: json['user_id'] as int?,
    );
  }
}
