import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/portfolio/portfolio_image.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class PortfoliosUseCase extends BaseUseCase<List<PortfolioModel>, NoParameters> {
  final AppRepositoryProvider repository;

  PortfoliosUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, List<PortfolioModel>>> call(NoParameters parameters) async {
    return await repository.getPortfolios();
  }

  @override
  Future<Either<ErrorModel, List<PortfolioModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}
