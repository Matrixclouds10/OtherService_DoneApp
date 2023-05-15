import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class MostRequestedProivdersUseCase extends BaseUseCase<List<ProvidersModel>, NoParameters> {
  final AppRepository repository;

  MostRequestedProivdersUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> call(NoParameters parameters) async {
    return await repository.getMostRequestedProviders();
  }

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}
