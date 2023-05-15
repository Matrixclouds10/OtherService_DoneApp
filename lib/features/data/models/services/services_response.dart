import 'service.dart';

class ServicesResponse {
  int? code;
  String? message;
  List<ServiceModel>? service;
  int totalPages = 1;

  ServicesResponse({this.code, required this.totalPages, this.message, this.service});

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      service: (json['data'] as List<dynamic>?)?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList(),
      totalPages: json['data']['meta']['pagination']['total_pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'service': service?.map((e) => e.toJson()).toList(),
      };
}
