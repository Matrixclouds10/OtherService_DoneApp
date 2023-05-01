import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import '../../repository/address_repository.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class AddressSetAsDefaultUsecase extends BaseUseCase<BaseResponse, int> {
  final AddressRepository _addressRepository;

  AddressSetAsDefaultUsecase(this._addressRepository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(int parameters) async {
    Either<ErrorModel, Response> response = await _addressRepository.addressSetAsDefaultRepository(parameters);
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
  Future<Either<ErrorModel, BaseResponse>> callTest(int body) async {
    return Left(ApiErrorHandler.getMessage("Test error"));
  }
}
