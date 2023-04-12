import 'dart:async';

import 'package:dio/dio.dart';
import 'package:weltweit/domain/repository/offer_repo.dart';

import '../app_urls/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class OfferRepositoryImp implements OfferRepository {
  final DioClient _dioClient;

  OfferRepositoryImp({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<ApiResponse> getOffers() async {
    try {
      Response response = await _dioClient.get(AppURL.kGetOffersURI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getOfferDetails({required int offerId}) async {
    try {
      Response response = await _dioClient.get(AppURL.kGetOfferDetailsURI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
