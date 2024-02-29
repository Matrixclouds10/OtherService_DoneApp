import 'package:weltweit/features/data/models/auth/user_model.dart';

class ProfileResponse {
  int? code;
  String? message;
  UserModel? userModel;

  ProfileResponse({this.code, this.message, this.userModel});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      userModel: json['user_model'] == null
          ? null
          : UserModel.fromJson(json['user_model'] as Map<String, dynamic>),
    );
  }
}
