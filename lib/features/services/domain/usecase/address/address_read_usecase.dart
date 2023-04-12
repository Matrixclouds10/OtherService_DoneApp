import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/features/services/data/model/response/address/address_data.dart';
import 'package:weltweit/features/services/data/model/response/address/address_item_model.dart';
import 'package:weltweit/features/services/data/model/response/address/addresses_response.dart';
import '../../repository/address_repository.dart';
import '../../request_body/address/address_read_body.dart';
import 'package:weltweit/features/services/core/base/base_usecase.dart';

class AddressReadUsecase
    extends BaseUseCase<List<AddressItemModel>, AddressReadBody> {
  final AddressRepository _addressRepository;

  AddressReadUsecase(this._addressRepository);

  @override
  Future<Either<ErrorModel, List<AddressItemModel>>> call(
      AddressReadBody parameters) async {
    Either<ErrorModel, Response> response = await _addressRepository
        .addressReadRepository(addressReadBody: parameters);
    return response.fold((l) {
      return Left(ApiErrorHandler.getMessage(l));
    }, (r) {
      Either<ErrorModel, List<AddressItemModel>> result = onConvert(r);
      return result;
    });
  }

  @override
  Either<ErrorModel, List<AddressItemModel>> onConvert(Response response) {
    try {
      AddressesResponse addressesResponse =
          AddressesResponse.fromJson(response.data);
      List<AddressItemModel> addressItemModels = [];
      if (addressesResponse.data == null)
        return Left(ApiErrorHandler.getMessage("data is null"));
      AddressData data = addressesResponse.data!;
      if (data.home != null) addressItemModels.add(data.home!);
      if (data.work != null) addressItemModels.add(data.work!);
      if (data.favorites != null) addressItemModels.addAll(data.favorites!);
      return Right(addressItemModels);
    } catch (e) {
      Logger().e(e);
      return Left(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, List<AddressItemModel>>> callTest(
      AddressReadBody body) async {
    return Left(ApiErrorHandler.getMessage("Test error"));
  }
}
