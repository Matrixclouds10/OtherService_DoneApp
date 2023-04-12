import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import '../../../core/base/base_usecase.dart';
import '../../repository/app_repo.dart';

class OrderUseCase extends BaseUseCase<OrderModel, int> {
  final AppRepository repository;

  OrderUseCase(this.repository);

  @override
  Future<Either<ErrorModel, OrderModel>> call(int parameters) async {
    return await repository.getOrder(params: parameters);
  }

  @override
  Future<Either<ErrorModel, OrderModel>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
