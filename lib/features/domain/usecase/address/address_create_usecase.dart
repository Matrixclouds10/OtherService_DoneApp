import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/address_repository.dart';

class AddressCreateUsecase extends BaseUseCase<BaseResponse, AddressCreateParams> {
  final AddressRepository _addressRepository;

  AddressCreateUsecase(this._addressRepository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(AddressCreateParams parameters) async {
    Either<ErrorModel, Response> response = await _addressRepository.addressCreateRepository(params: parameters);
    return response.fold((l) {
      return Left(ApiErrorHandler.getMessage(l));
    }, (r) {
      Either<ErrorModel, BaseResponse> result = onConvert(r);
      return result;
    });
  }

  Either<ErrorModel, BaseResponse> onConvert(Response response) {
    try {
      BaseResponse basicResponse = BaseResponse.fromJson(response.data);
      return Right(basicResponse);
    } catch (e) {
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(AddressCreateParams body) async {
    return Left(ApiErrorHandler.getMessage("Test error"));
  }
}

class AddressCreateParams {
  final String name;
  final String address;
  final String? lat;
  final String? lng;

  AddressCreateParams({required this.name, required this.address, this.lat, this.lng});
  toJson() {
    return {
      "name": name,
      "address": address,
      "lat": lat ?? "0",
      "lng": lng ?? "0",
    };
  }
}
