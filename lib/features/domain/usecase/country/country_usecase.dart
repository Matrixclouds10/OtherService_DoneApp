import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/response/country/country_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class CountryUseCase extends BaseUseCase<CountryModel, int> {
  final AppRepository repository;

  CountryUseCase(this.repository);

  @override
  Future<Either<ErrorModel, CountryModel>> call(int parameters) async {
    return await repository.getcountry(id: parameters);
  }

  @override
  Future<Either<ErrorModel, CountryModel>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
