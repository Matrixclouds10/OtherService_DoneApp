import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_create_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_delete_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_read_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_update_usecase.dart';

abstract class AddressRepository {
  Future<Either<ErrorModel, Response>> addressCreateRepository({required AddressCreateParams params});
  Future<Either<ErrorModel, Response>> addressUpdateRepository({required AddressUpdateParams params});
  Future<Either<ErrorModel, Response>> addressReadRepository({AddressReadParams? params});
  Future<Either<ErrorModel, Response>> addressDeleteRepository({required AddressDeleteParams params});
}
