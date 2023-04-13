import 'service.dart';

class ServicesResponse {
  int? code;
  String? message;
  List<ServiceModel>? service;

  ServicesResponse({this.code, this.message, this.service});

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      service: (json['data'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'service': service?.map((e) => e.toJson()).toList(),
      };
}
