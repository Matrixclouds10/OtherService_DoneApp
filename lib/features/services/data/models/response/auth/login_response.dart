import 'user_model.dart';

class LoginResponse {
  int? code;
  String? message;
  UserModel? userModel;

  LoginResponse({this.code, this.message, this.userModel});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json['code'] as int?,
        message: json['message'] as String?,
        userModel: json['user_model'] == null
            ? null
            : UserModel.fromJson(json['user_model'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'user_model': userModel?.toJson(),
      };
}
