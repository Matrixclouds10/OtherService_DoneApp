import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';

import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class UpdateProfileLocationUseCase implements BaseUseCase<BaseResponse, UpdateProfileLocationParams> {
  final ProviderRepositoryProvider repository;

  UpdateProfileLocationUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(UpdateProfileLocationParams parameters) async {
    return await repository.updateLocation(lat: parameters.lat, lng: parameters.lng);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(UpdateProfileLocationParams params) {
    throw UnimplementedError();
  }
}


class UpdateProfileLocationParams {
  String lat;
  String lng;

  UpdateProfileLocationParams({required this.lat, required this.lng});
}