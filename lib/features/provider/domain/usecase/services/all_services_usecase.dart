import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/provider/data/models/response/services/service.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';

class AllServicesUseCase extends BaseUseCase<List<ServiceModel>, NoParameters> {
  final AppRepository repository;

  AllServicesUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> call(
      NoParameters parameters) async {
    return await repository.getAllServices();
  }

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> callTest(
      NoParameters parameters) {
    throw UnimplementedError();
  }
}