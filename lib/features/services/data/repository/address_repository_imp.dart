import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/dio/dio_client.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';

import '../../domain/request_body/address/address_create_body.dart';
import '../../domain/request_body/address/address_delete_body.dart';
import '../../domain/request_body/address/address_read_body.dart';
import '../../domain/request_body/address/address_update_body.dart';
import '../../domain/repository/address_repository.dart';
import '../app_urls/app_url.dart';

class AddressRepositoryImp implements AddressRepository {
  final DioClient _dioClient;
  AddressRepositoryImp({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Either<ErrorModel, Response>> addressDeleteRepository(
      {required AddressDeleteBody addressDeleteBody}) async {
    Map<String, dynamic> params = {};
    params['id'] = id;
    try {
      Response response = await _dioClient.post(AppURL.addressDeleteUrl,
          queryParameters: addressDeleteBody.toJson());
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, Response>> addressReadRepository(
      {AddressReadBody? addressReadBody}) async {
    try {
      Response response = await _dioClient.get(AppURL.addressReadUrl,
          queryParameters: addressReadBody?.toJson());
      return Right(response);
    } catch (e) {
      Logger().e(e.toString());
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, Response>> addressCreateRepository(
      {required AddressCreateBody addressCreateBody}) async {
    try {
      Response response = await _dioClient.post(AppURL.addressCreateUrl,
          parameters: addressCreateBody.toJson());
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, Response>> addressUpdateRepository(
      {required AddressUpdateBody addressUpdateBody}) async {
    try {
      Response response = await _dioClient.post(AppURL.addressUpdateUrl,
          parameters: addressUpdateBody.toJson());
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }
}
