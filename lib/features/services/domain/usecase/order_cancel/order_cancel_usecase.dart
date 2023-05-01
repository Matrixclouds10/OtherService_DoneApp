import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';

class OrderCancelUseCase extends BaseUseCase<BaseResponse, OrderCancelParams> {
  final AppRepository repository;

  OrderCancelUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(OrderCancelParams parameters) async {
    return await repository.cancelOrder(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(OrderCancelParams parameters) {
    throw UnimplementedError();
  }
}

class OrderCancelParams {
  int id;
  String reason;

  OrderCancelParams({
    required this.id,
    required this.reason,
  });

  toJson() {
    return {
      'order_id': id,
      'reason': reason,
    };
  }
}

