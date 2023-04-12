import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import '../../domain/request_body/address/address_create_body.dart';
import '../../domain/request_body/address/address_delete_body.dart';
import '../../domain/request_body/address/address_read_body.dart';
import '../../domain/request_body/address/address_update_body.dart';

abstract class AddressRepository {
  Future<Either<ErrorModel, Response>> addressCreateRepository({required AddressCreateBody addressCreateBody});
  Future<Either<ErrorModel, Response>> addressUpdateRepository({required AddressUpdateBody addressUpdateBody});
  Future<Either<ErrorModel, Response>> addressReadRepository({AddressReadBody? addressReadBody});
  Future<Either<ErrorModel, Response>> addressDeleteRepository({required AddressDeleteBody addressDeleteBody});
}
