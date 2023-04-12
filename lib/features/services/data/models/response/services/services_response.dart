import 'service.dart';

class ServicesResponse {
  int? code;
  String? message;
  List<ServiceModel>? service;
  int totalPages;
  ServicesResponse(
      {this.code, required this.totalPages, this.message, this.service});

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      // code: json['code'] as int?,
      // message: json['message'] as String?,
      // service: (json['data']['data'] as List<dynamic>?)?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList(),
      totalPages: json['data']['meta']['pagination']['total_pages'] as int,
    );
  }
}
