import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class OrderRateUseCase extends BaseUseCase<BaseResponse, OrderRateParams> {
  final AppRepository repository;

  OrderRateUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(OrderRateParams parameters) async {
    return await repository.orderRate(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(OrderRateParams parameters) {
    throw UnimplementedError();
  }
}

class OrderRateParams {
  final int providerId;
  final int clientId;
  final int rate;
  final String fromType;
  final String comment;
  final int orderId;

  OrderRateParams({
    required this.providerId,
    required this.clientId,
    required this.rate,
    required this.fromType,
    required this.comment,
    required this.orderId,
  });

  toJson() {
    return {
      'provider_id': providerId,
      'client_id': clientId,
      'rate': rate,
      'from_type': fromType,
      'comment': comment,
      'order_id': orderId,
    };
  }
}
