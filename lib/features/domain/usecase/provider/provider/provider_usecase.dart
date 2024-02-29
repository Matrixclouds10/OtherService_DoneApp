import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class ProviderUseCase extends BaseUseCase<ProvidersModel, int> {
  final AppRepository repository;

  ProviderUseCase(this.repository);

  @override
  Future<Either<ErrorModel, ProvidersModel>> call(int parameters) async {
    return await repository.getProvider(id: parameters);
  }

  @override
  Future<Either<ErrorModel, ProvidersModel>> callTest(int parameters) {
    throw UnimplementedError();
  }
}

