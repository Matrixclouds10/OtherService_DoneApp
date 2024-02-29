import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/data/models/services/service.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.date,
    required this.file,
    required this.status,
    required this.statusCode,
    required this.client,
    required this.price,
    required this.provider,
    required this.cancelReason,
    required this.service,
    required this.rate,
  });

  final int id;
  final DateTime date;
  final List<String> file;
  final String status;
  final String? price;
  final String? statusCode;
  final Client? client;
  final String? cancelReason;
  final ProvidersModel? provider;
  final ServiceModel? service;
  final RateModel? rate;
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        file: json["file"] == null ? [] : List<String>.from(json["file"].map((x) => x)),
        status: json["status"] ?? "",
        statusCode: json["status_code"],
        price: json["price"] == null ? null : '${json["price"]}',
        client: Client.fromJson(json["client"]),
        cancelReason: json["cancel_reason"],
        provider: ProvidersModel.fromJson(json["provider"]),
        service: ServiceModel.fromJson(json["service"]),
        rate: json["rate"] == null? null:RateModel.fromJson(json["rate"]),
      );
}

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
