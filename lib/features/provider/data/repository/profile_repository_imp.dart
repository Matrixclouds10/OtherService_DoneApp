import 'dart:async';

import 'package:weltweit/data/datasource/remote/dio/dio_client.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/features/data/models/base/api_response.dart';
import 'package:weltweit/features/provider/domain/request_body/profile_body.dart';

import '../../domain/repository/profile_repo.dart';
import '../app_urls/app_url.dart';

class ProfileRepositoryImp implements ProfileRepository {
  final DioClient _dioClient;

  const ProfileRepositoryImp({
    required DioClient dioClient,
  }) : _dioClient = dioClient;
  @override
  Future<ApiResponse> getProfile() async {
    try {
      Response response = await _dioClient.get(AppURL.profile);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateProfile({required ProfileBody profileBody}) async {
    try {
      Response response = await _dioClient.post(
        AppURL.updateProfile,
        queryParameters: profileBody.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
