import 'package:weltweit/features/data/models/location/city_model.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/data/models/location/region_model.dart';

class UserModel {
  int? id;
  String? name;
  String? isOnline;
  String? email;
  String? mobileNumber;
  String? whatsAppNumber;
  String? token;
  int? approved;
  dynamic otpVerified;
  String? countryCode;
  String? image;
  String gender;
  String? desc;
  bool? percentage;
  int? points;
  CodeModel? code;
  // int? isCompany;
  CountryModel? countryModel;
  CityModel? cityModel;
  RegionModel? regionModel;
  String? wallet;
  int? countryId;
  CurrentSubscribtion? currentSubscription;
  UserModel({
    this.id,
    this.name,
    this.isOnline,
    this.email,
    this.percentage,
    this.code,
    this.points,
    required this.gender,
    this.mobileNumber,
    this.whatsAppNumber,
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
    this.cityModel,
    this.regionModel,
  });

  bool isAvailable() {
    //|| '$isOnline'.toLowerCase() == "on"
    return (('$isOnline'.toLowerCase() == "yes") &&(currentSubscription != null && (currentSubscription?.isExpired == false))) ||('$isOnline'.toLowerCase() == "yes") && percentage !=false ;
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
      whatsAppNumber: json['whatsapp_number'] as String?,
      token: json['token'] == null ? null : '${json['token']}',
      approved: json['approved'] as int?,
      points: json['points'] as int?,
      otpVerified: json['otp'] as dynamic?,
      countryCode: json['country_code'] as String?,
      image: json['image'] as String?,
      percentage: json['percentage'] as bool?,
      gender: json['gender'] ?? "male",
      desc: json['description'] ?? "",
      // isCompany: json['is_company'] as int?,
      countryModel: countryJson != null ? CountryModel.fromJson(countryJson) : null,
      wallet: "${json['wallets']}",
      cityModel: json['city'] != null ? CityModel.fromJson(json['city']) : null,
      code: json['code'] != null ? CodeModel.fromJson(json['code']) : null,
      regionModel: json['region'] != null ? RegionModel.fromJson(json['region']) : null,
      countryId: json['country_id'] == null ? null : int.tryParse('${json['country_id']}'),
      currentSubscription: json['current_subscription'] != null ? CurrentSubscribtion.fromJson(json['current_subscription']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'is_online': this.isOnline,
      'email': this.email,
      'mobile_number': this.mobileNumber,
      'whatsapp_number': this.whatsAppNumber,
      'token': this.token,
      'approved': this.approved,
      'otp': this.otpVerified,
      'country_code': this.countryCode,
      'image': this.image,
      'gender': this.gender,
      'desc': this.desc,
      'percentage': this.percentage,
      'points': this.points,
      'code': this.code,
      'countryModel': this.countryModel,
      'cityModel': this.cityModel,
      'regionModel': this.regionModel,
      'wallet': this.wallet,
      'country_id': this.countryId,
      'current_subscription': this.currentSubscription,
    };
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
  bool? isExpired;

  CurrentSubscribtion({
    this.id,
    this.providerId,
    this.subscriptionId,
    this.startsAt,
    this.endsAt,
    this.createdAt,
    this.isExpired,
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
      isExpired: isExpiredData(DateTime.parse(DateTime.parse(json['ends_at']).toString())),
      userId: json['user_id'] as int?,
    );
  }

}
bool isExpiredData(DateTime givenDate) {
  DateTime currentDate = DateTime.now();
  return currentDate.isAtSameMomentAs(givenDate) || currentDate.isAfter(givenDate);
}

class CodeModel {
  int? id;
  int? clientId;
  String? code;
  String? expireDate;
  String? createdAt;
  String? updatedAt;

  CodeModel(
      {this.id,
        this.clientId,
        this.code,
        this.expireDate,
        this.createdAt,
        this.updatedAt});

  CodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    code = json['code'];
    expireDate = json['expire_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['code'] = this.code;
    data['expire_date'] = this.expireDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

