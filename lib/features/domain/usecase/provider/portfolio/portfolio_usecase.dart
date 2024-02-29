import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/portfolio/portfolio_image.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class PortfolioUseCase extends BaseUseCase<List<PortfolioModel>, int> {
  final AppRepository repository;

  PortfolioUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<PortfolioModel>>> call(int parameters) async {
    return await repository.getProviderPortfolio(id: parameters);
  }

  @override
  Future<Either<ErrorModel, List<PortfolioModel>>> callTest(int parameters) {
    throw UnimplementedError();
  }
}

