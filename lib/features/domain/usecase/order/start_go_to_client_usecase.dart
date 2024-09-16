import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class StartGoToClientUseCase extends BaseUseCase<BaseResponse, StartGoToClientParams> {
  final AppRepository repository;

  StartGoToClientUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(StartGoToClientParams parameters) async {
    return await repository.startGoToClient(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(StartGoToClientParams parameters) {
    throw UnimplementedError();
  }
}

class StartGoToClientParams {
  int id;

  StartGoToClientParams({
    required this.id,
  });

  toJson() {
    return {
      'order_id': id,
    };
  }
}

