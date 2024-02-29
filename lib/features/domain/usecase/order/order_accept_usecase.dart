import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class OrderAcceptUseCase extends BaseUseCase<BaseResponse, OrderAcceptParams> {
  final AppRepository repository;

  OrderAcceptUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(OrderAcceptParams parameters) async {
    return await repository.acceptOrder(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(OrderAcceptParams parameters) {
    throw UnimplementedError();
  }
}

class OrderAcceptParams {
  int id;

  OrderAcceptParams({
    required this.id,
  });

  toJson() {
    return {
      'order_id': id,
    };
  }
}

