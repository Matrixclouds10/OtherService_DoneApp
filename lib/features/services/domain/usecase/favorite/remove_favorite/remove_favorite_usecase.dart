import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import '../../../../../core/base/base_usecase.dart';
import '../../../repository/app_repo.dart';

class RemoveFavoriteUseCase extends BaseUseCase<BaseResponse, int> {
  final AppRepository repository;

  RemoveFavoriteUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(int parameters) async {
    return await repository.addToFavorites(id: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
