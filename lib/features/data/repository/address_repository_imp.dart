import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/dio/dio_client.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/domain/repositoy/address_repository.dart';
import 'package:weltweit/features/domain/usecase/address/address_create_usecase.dart';
import 'package:weltweit/features/domain/usecase/address/address_delete_usecase.dart';
import 'package:weltweit/features/domain/usecase/address/address_read_usecase.dart';
import 'package:weltweit/features/domain/usecase/address/address_update_usecase.dart';
import 'package:weltweit/features/data/app_urls/client_endpoints_url.dart';


class AddressRepositoryImp implements AddressRepository {
  final DioClient _dioClient;
  AddressRepositoryImp({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Either<ErrorModel, Response>> addressDeleteRepository({required AddressDeleteParams params}) async {
    try {
      Response response = await _dioClient.post(AppURL.addressDeleteUrl, queryParameters: params.toJson());
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, Response>> addressReadRepository({AddressReadParams? params}) async {
    try {
      Response response = await _dioClient.get(AppURL.addressReadUrl, queryParameters: params?.toJson());
      return Right(response);
    } catch (e) {
      Logger().e(e.toString());
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, Response>> addressCreateRepository({required AddressCreateParams params}) async {
    try {
      Response response = await _dioClient.post(AppURL.addressCreateUrl, queryParameters: params.toJson());
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, Response>> addressUpdateRepository({required AddressUpdateParams params}) async {
    try {
      print(params.toJson());
      Response response = await _dioClient.post(AppURL.addressUpdateUrl, queryParameters: params.toJson());
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }
  @override
  Future<Either<ErrorModel, Response>> addressSetAsDefaultRepository(int id) async {
    try {
      Response response = await _dioClient.post('${AppURL.addressSetDefaultUrl}/$id');
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }
}
