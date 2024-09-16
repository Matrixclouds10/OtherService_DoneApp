import 'package:easy_localization/easy_localization.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/data/models/services/service.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.date,
     this.file,
    required this.status,
    required this.statusCode,
    required this.client,
    required this.price,
    required this.provider,
     this.distance2,
     this.distance,
     this.estimatedTime,
     this.allStatus,
    required this.cancelReason,
    required this.service,
    required this.rate,
  });

  final int id;
  final DateTime date;
  final List<String>? file;
  final String status;
  final String? price;
  final String? statusCode;
  final List<String>? allStatus;
  final Client? client;
  final String? distance2;
  final dynamic distance;
  final dynamic estimatedTime;
  final String? cancelReason;
  final ProvidersModel? provider;
  final ServiceModel? service;
  final RateModel? rate;
  factory OrderModel.fromJson(Map<String, dynamic> json)
  {
    return  OrderModel(
      id: json["id"],
      date:format.parse(json["date"]),
       file: json["file"] == null ? [] : List<String>.from(json["file"].map((x) => x)),
      status: json["status"] ?? "",
      statusCode: json["status_code"],
      allStatus: json["all_status"] == null ? [] : List<String>.from(json["all_status"].map((x) => x)),
      price: json["price"] == null ? null : '${json["price"]}',
      client: Client.fromJson(json["client"]),
      distance: json["distance"],
      estimatedTime: json["estimated_time"],
      provider: ProvidersModel.fromJson(json["provider"]),
      service: ServiceModel.fromJson(json["service"]),
      rate: json["rate"] == null? null:RateModel.fromJson(json["rate"]),
      cancelReason:  json["cancel_reason"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'date': this.date,
      'file': this.file,
      'status': this.status,
      'price': this.price,
      'status_code': this.statusCode,
      'all_status': this.allStatus,
      'client': this.client,
      'distance': this.distance2,
      'distance': this.distance,
      'estimated_time': this.estimatedTime,
      'cancelReason': this.cancelReason,
      'provider': this.provider,
      'service': this.service,
      'rate': this.rate,
    };
  }

}
// Define the format pattern
DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");


class Client {
  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.otpVerified,
    required this.countryCode,
    required this.gender,
    required this.image,
  });

  final int id;
  final String name;
  final String email;
  final String mobileNumber;
  final int otpVerified;
  final String countryCode;
  final String gender;
  final String image;

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        otpVerified: json["otp_verified"],
        countryCode: json["country_code"],
        gender: json["gender"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "otp_verified": otpVerified,
        "country_code": countryCode,
        "gender": gender,
        "image": image,
      };
}

class RateModel {
  final int? rate;
  final String? comment;

  RateModel({
    this.rate,
    this.comment,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        rate: json["rate"],
        comment: json["comment"],
      );
}
