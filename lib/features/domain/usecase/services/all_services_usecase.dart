import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/services/services_response.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class AllServicesUseCase extends BaseUseCase<ServicesResponse, int> {
  final AppRepository repository;

  AllServicesUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, ServicesResponse>> call(int parameters) async {
    return await repository.getAllServices(page: parameters);
  }

  @override
  Future<Either<ErrorModel, ServicesResponse>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
