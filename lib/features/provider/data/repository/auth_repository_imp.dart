import 'dart:async';

import 'package:weltweit/data/datasource/remote/dio/dio_client.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/data/models/base/api_response.dart';
import 'package:weltweit/features/services/domain/request_body/register_body.dart';

import '../../domain/request_body/check_otp_body.dart';
import '../../domain/request_body/login_body.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/auth_repo.dart';
import '../app_urls/app_url.dart';

class AuthRepositoryImp implements AuthRepository {
  final DioClient _dioClient;

  const AuthRepositoryImp({
    required DioClient dioClient,
  }) : _dioClient = dioClient;
  @override
  Future<ApiResponse> login({required LoginBody loginBody}) async {
    try {
      Response response = await _dioClient.post(
       AppURL.loginURI,
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
      FormData? formData;
      // if (registerBody.image != null) {
      //   formData = FormData.fromMap({
      //     'image': await MultipartFile.fromFile(registerBody.image!.path,
      //         filename: registerBody.image!.path.split('/').last),
      //   });
      // }
      Response response = await _dioClient.post(
       AppURL.registerURI,
        queryParameters: registerBody.toJson(),
        data: formData,
        cancelToken: CancelToken(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> logout() async {
    try {
      Response response = await _dioClient.get( AppURL.logoutURI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> forgetPassword({String? phone}) async {
    try {
      Response response = await _dioClient.post(
       AppURL.forgetPasswordURI,
        queryParameters: {'mobile': phone},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> otpCode({required CheckOTPBody checkOTPBody}) async {
    try {
      Response response = await _dioClient.post(
       AppURL.kCheckOTPURI,
        queryParameters: checkOTPBody.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> resetPassword(
      {required String phone, required String password}) async {
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
  Future<ApiResponse> updateFCMToken(
      {required String fcmToken, required String deviceType}) async {
    try {
      Response response = await _dioClient.post(
         AppURL.kUpdateFCMTokenURI,
          queryParameters: {'phone_token': fcmToken, 'type': deviceType});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
