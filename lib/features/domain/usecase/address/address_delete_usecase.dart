import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/domain/repositoy/address_repository.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class AddressDeleteUsecase
    extends BaseUseCase<BaseResponse, AddressDeleteParams> {
  final AddressRepository _addressRepository;

  AddressDeleteUsecase(this._addressRepository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(
      AddressDeleteParams parameters) async {
    Either<ErrorModel, Response> response = await _addressRepository
        .addressDeleteRepository(params: parameters);
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
  Future<Either<ErrorModel, BaseResponse>> callTest(
      AddressDeleteParams parameters) async {
    return Left(ApiErrorHandler.getMessage("Test error"));
  }
}
class AddressDeleteParams {
  final String id;

  AddressDeleteParams({required this.id});
  toJson() {
    return {
      "id": id,
    };
  }
}