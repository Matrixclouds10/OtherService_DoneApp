import 'address_data.dart';

class AddressesResponse {
  int? code;
  String? message;
  AddressData? data;

  AddressesResponse({this.code, this.message, this.data});

  factory AddressesResponse.fromJson(Map<String, dynamic> json) {
    return AddressesResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : AddressData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data?.toJson(),
      };
}
