import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/location/city_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class CitiesUseCase extends BaseUseCase<List<CityModel>, CitiesParams> {
  final AppRepository repository;

  CitiesUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<CityModel>>> call(CitiesParams parameters) async {
    return await repository.getCities(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<CityModel>>> callTest(CitiesParams parameters) {
    throw UnimplementedError();
  }
}

class CitiesParams {
  final int countryId;

  CitiesParams({required this.countryId});

  Map<String, dynamic> toJson() => {"country_id": countryId};
}
