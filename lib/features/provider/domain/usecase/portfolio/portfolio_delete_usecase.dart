import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';

class PortfolioDeleteUseCase extends BaseUseCase<BaseResponse, int> {
  final AppRepository repository;

  PortfolioDeleteUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(int parameters) async {
    return await repository.deletePortfolio(id: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
