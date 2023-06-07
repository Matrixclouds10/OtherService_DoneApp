import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/features/data/models/base/api_response.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/domain/request_body/register_body.dart';
import 'package:weltweit/features/domain/usecase/auth/sign_in_usecase.dart';

import '../../../data/app_urls/app_url.dart';
import '../../../data/datasource/remote/dio/dio_client.dart';
import '../../../data/datasource/remote/exception/api_error_handler.dart';
import '../../domain/repositoy/auth_repo.dart';

class AuthRepositoryImp implements AuthRepository {
  final DioClient _dioClient;

  const AuthRepositoryImp({
    required DioClient dioClient,
  }) : _dioClient = dioClient;
  @override
  Future<ApiResponse> login({required LoginParams loginBody, required bool typeIsProvider}) async {
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
     
      Response response = await _dioClient.post(
        url,
        queryParameters: registerBody.toJson(),
        // filePath: registerBody.image?.path,
        // ignorePath: true,
      );
      Sentry.captureMessage("Register response: ${response.data.toString()}");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      Sentry.captureMessage("Register Error: ${e.toString()}");
      Sentry.captureException(e);
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
  Future<ApiResponse> forgetPassword({String? email,required bool typeIsProvider}) async {
    try {
    String url = typeIsProvider ? AppURL.kForgetPasswordProviderURI : AppURL.kForgetPasswordURI;
    kEcho("Forget Password URL: $url");
      Response response = await _dioClient.post(
        url,
        queryParameters: {'email': email},
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
  Future<ApiResponse> resetPassword({required String email, required String password}) async {
    try {
      Response response = await _dioClient.post(
        AppURL.kResetPasswordURI,
        queryParameters: {'email': email, 'password': password},
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
