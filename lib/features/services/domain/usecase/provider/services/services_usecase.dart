import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import '../../../../../core/base/base_usecase.dart';
import '../../../repository/app_repo.dart';

class ProviderServicesUseCase extends BaseUseCase<List<ServiceModel>, int> {
  final AppRepository repository;

  ProviderServicesUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> call(int parameters) async {
    return await repository.getProviderServices(id: parameters);
  }

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
