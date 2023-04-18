import 'dart:async';

import 'package:dio/dio.dart';
import 'package:weltweit/features/data/models/base/api_response.dart';
import 'package:weltweit/features/services/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/services/domain/request_body/login_body.dart';
import 'package:weltweit/features/services/domain/request_body/register_body.dart';

import '../../domain/repositoy/auth_repo.dart';
import '../../../data/app_urls/app_url.dart';
import '../../../data/datasource/remote/dio/dio_client.dart';
import '../../../data/datasource/remote/exception/api_error_handler.dart';

class AuthRepositoryImp implements AuthRepository {
  final DioClient _dioClient;

  const AuthRepositoryImp({
    required DioClient dioClient,
  }) : _dioClient = dioClient;
  @override
  Future<ApiResponse> login({required LoginBody loginBody, required bool typeIsProvider}) async {
    try {
      String url = typeIsProvider ? AppURL.kLoginProviderURI : AppURL.kLoginURI;
      Response response = await _dioClient.post(
        url,
        queryParameters: loginBody.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> register({required RegisterBody registerBody}) async {
    try {
      String url = registerBody.typeIsProvider ? AppURL.kRegisterProviderURI : AppURL.kRegisterURI;
      FormData formData = FormData.fromMap({
        'name': registerBody.name,
        'email': registerBody.email,
        'phone': registerBody.mobile,
        'password': registerBody.password,
      });
      Response response = await _dioClient.post(
        url,
        data: formData,
        // filePath: registerBody.image?.path,
        // ignorePath: true,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> logout() async {
    try {
      Response response = await _dioClient.get(AppURL.kLogoutURI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> forgetPassword({String? phone}) async {
    try {
      Response response = await _dioClient.post(
        AppURL.kForgetPasswordURI,
        queryParameters: {'mobile': phone},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> otpCode({required CheckOTPBody checkOTPBody}) async {
    String url = checkOTPBody.typeIsProvider ? AppURL.kCheckOTPProviderURI : AppURL.kCheckOTPURI;
    try {
      Response response = await _dioClient.post(
        url,
        queryParameters: checkOTPBody.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> resetPassword({required String phone, required String password}) async {
    try {
      Response response = await _dioClient.post(
        AppURL.kResetPasswordURI,
        queryParameters: {'phone': phone, 'password': password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> deleteAccount() async {
    try {
      Response response = await _dioClient.post(
        AppURL.kDeleteAccountURI,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateFCMToken({required String fcmToken, required String deviceType}) async {
    try {
      Response response = await _dioClient.post(AppURL.kUpdateFCMTokenURI, queryParameters: {'phone_token': fcmToken, 'type': deviceType});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
