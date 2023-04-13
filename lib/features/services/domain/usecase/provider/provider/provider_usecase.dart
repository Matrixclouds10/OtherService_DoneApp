import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import '../../../../../core/base/base_usecase.dart';
import '../../../repository/app_repo.dart';

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

