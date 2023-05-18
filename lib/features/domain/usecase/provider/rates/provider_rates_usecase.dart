import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/provider/provider_rates_model.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class ProviderRatesUseCase extends BaseUseCase<List<ProviderRateModel>, int> {
  final AppRepository repository;

  ProviderRatesUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<ProviderRateModel>>> call(int parameters) async {
    return await repository.getProviderRates(id: parameters);
  }

  @override
  Future<Either<ErrorModel, List<ProviderRateModel>>> callTest(int parameters) {
    throw UnimplementedError();
  }
}

