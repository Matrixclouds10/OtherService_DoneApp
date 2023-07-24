import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/location/region_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class RegionsUseCase extends BaseUseCase<List<RegionModel>, RegionsParams> {
  final AppRepository repository;

  RegionsUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<RegionModel>>> call(RegionsParams parameters) async {
    return await repository.getRegions(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<RegionModel>>> callTest(RegionsParams parameters) {
    throw UnimplementedError();
  }
}

class RegionsParams {
  final int cityId;

  RegionsParams({required this.cityId});

  Map<String, dynamic> toJson() => {"city_id": cityId};
}
