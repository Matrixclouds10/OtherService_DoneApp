import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class UpdateServicesUseCase
    extends BaseUseCase<List<ServiceModel>, UpdateServicesParams> {
  final AppRepositoryProvider repository;

  UpdateServicesUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> call(
      UpdateServicesParams parameters) async {
    return await repository.updateMyServices(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> callTest(
      UpdateServicesParams parameters) {
    throw UnimplementedError();
  }
}

class UpdateServicesParams {
  List<ServiceModel> services;

  UpdateServicesParams({required this.services});

  toJson() {
    return {
      for (int i = 0; i < services.length; i++)
        "services_ids[$i]": '${services[i].id}',
    };
  }
}
