import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import '../../repository/address_repository.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class AddressUpdateUsecase
    extends BaseUseCase<BaseResponse, AddressUpdateParams> {
  final AddressRepository _addressRepository;

  AddressUpdateUsecase(this._addressRepository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(
      AddressUpdateParams parameters) async {
    Either<ErrorModel, Response> response = await _addressRepository
        .addressUpdateRepository(params: parameters);
    return response.fold((l) {
      return Left(ApiErrorHandler.getMessage(l));
    }, (r) {
      Either<ErrorModel, BaseResponse> result = onConvert(r);
      return result;
    });
  }

  @override
  Either<ErrorModel, BaseResponse> onConvert(Response response) {
    try {
      BaseResponse basicResponse = BaseResponse.fromJson(response.data);
      return Right(basicResponse);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(
      AddressUpdateParams body) async {
    return Left(ApiErrorHandler.getMessage("Test error"));
  }
}
class AddressUpdateParams {
  final int id;
  final String name;
  final String address;
  final String? lat;
  final String? lng;

  AddressUpdateParams({required this.id, required this.name, required this.address, this.lat, this.lng});
  toJson() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "lat": "0.0",
      "lng": "0.0",
    };
  }
}