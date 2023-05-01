import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';

class PolicyUseCase extends BaseUseCase<BaseResponse, NoParameters> {
  final AppRepository repository;

  PolicyUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(NoParameters parameters) async {
    return await repository.getPolicy();
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

