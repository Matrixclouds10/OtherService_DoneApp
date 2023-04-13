import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import '../../../../core/base/base_usecase.dart';
import '../../repository/app_repo.dart';

class FavoriteUseCase extends BaseUseCase<List<ProvidersModel>, NoParameters> {
  final AppRepository repository;

  FavoriteUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> call(NoParameters parameters) async {
    return await repository.getFavorites();
  }

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

