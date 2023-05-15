import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/response/country/country_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class CountriesUseCase extends BaseUseCase<List<CountryModel>, NoParameters> {
  final AppRepository repository;

  CountriesUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<CountryModel>>> call(NoParameters parameters) async {
    return await repository.getCountries(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<CountryModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

