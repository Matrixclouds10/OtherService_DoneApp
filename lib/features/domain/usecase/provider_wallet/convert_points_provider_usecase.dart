import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/wallet/wallet_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

import '../../../core/base/base_response.dart';
import '../../repositoy/app_repo.dart';

class ConvertPointsProviderUseCase extends BaseUseCase<BaseResponse, NoParameters> {
  final AppRepositoryProvider repository;

  ConvertPointsProviderUseCase(this.repository);

  @override
  Future<Either<ErrorModel,BaseResponse>> call(NoParameters parameters) async {
    return await repository.convertPoints();
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

