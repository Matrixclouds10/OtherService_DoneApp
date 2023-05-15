import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class PortfolioUpdateUseCase extends BaseUseCase<BaseResponse, PortfolioParams> {
  final ProviderRepositoryProvider repository;

  PortfolioUpdateUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(PortfolioParams parameters) async {
    return await repository.updatePortfolio(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(PortfolioParams parameters) {
    throw UnimplementedError();
  }
}

class PortfolioParams {
  final File image;
  final int id;

  PortfolioParams({required this.image, required this.id});
}
