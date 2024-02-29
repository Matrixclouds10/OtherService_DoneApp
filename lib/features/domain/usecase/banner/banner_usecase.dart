import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/banner/banner_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class BannerUseCase extends BaseUseCase<List<BannerModel>, BannerParams> {
  final AppRepository repository;

  BannerUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<BannerModel>>> call(BannerParams parameters) async {
    return await repository.getbanner(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<BannerModel>>> callTest(BannerParams parameters) {
    throw UnimplementedError();
  }
}

class BannerParams {
  BannerParams();
  toJSon() {}
}