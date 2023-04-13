import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';

class PortfolioAddUseCase extends BaseUseCase<BaseResponse, File> {
  final AppRepositoryProvider repository;

  PortfolioAddUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(File parameters) async {
    return await repository.addPortfolio(image: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(File parameters) {
    throw UnimplementedError();
  }
}
