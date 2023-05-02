import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/services/data/models/response/address/address_data.dart';
import 'package:weltweit/features/services/data/models/response/address/address_item_model.dart';
import 'package:weltweit/features/services/data/models/response/address/addresses_response.dart';
import '../../repository/address_repository.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class AddressReadUsecase extends BaseUseCase<List<AddressItemModel>, AddressReadParams> {
  final AddressRepository _addressRepository;

  AddressReadUsecase(this._addressRepository);

  @override
  Future<Either<ErrorModel, List<AddressItemModel>>> call(AddressReadParams parameters) async {
    Either<ErrorModel, Response> response = await _addressRepository.addressReadRepository(params: parameters);
    return response.fold((l) {
      return Left(ApiErrorHandler.getMessage(l));
    }, (r) {
      Either<ErrorModel, List<AddressItemModel>> result = onConvert(r);
      return result;
    });
  }

  Either<ErrorModel, List<AddressItemModel>> onConvert(Response response) {
    try {
      AddressesResponse addressesResponse = AddressesResponse.fromJson(response.data);
      List<AddressItemModel> addressItemModels = [];
      if (addressesResponse.data == null) return Left(ApiErrorHandler.getMessage("data is null"));
      AddressData data = addressesResponse.data!;
      if (data.home != null && data.home!.name != null ) addressItemModels.add(data.home!);
      if (data.work != null&& data.work!.name != null) addressItemModels.add(data.work!);
      if (data.favorites != null) addressItemModels.addAll(data.favorites!);
      return Right(addressItemModels);
    } catch (e) {
      Logger().e(e);
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, List<AddressItemModel>>> callTest(AddressReadParams body) async {
    return Left(ApiErrorHandler.getMessage("Test error"));
  }
}

class AddressReadParams {
  toJson() {}
}
