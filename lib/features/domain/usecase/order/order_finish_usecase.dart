import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class OrderFinishUseCase extends BaseUseCase<BaseResponse, OrderFinishParams> {
  final AppRepository repository;

  OrderFinishUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(OrderFinishParams parameters) async {
    return await repository.finishOrder(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(OrderFinishParams parameters) {
    throw UnimplementedError();
  }
}

class OrderFinishParams {
  int id;
  String price;

  OrderFinishParams({
    required this.id,
    required this.price,
  });

  toJson() {
    return {
      'order_id': id,
      'reason': price,
    };
  }
}

