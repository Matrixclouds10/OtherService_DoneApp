import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import '../../../../core/base/base_usecase.dart';
import '../../repository/app_repo.dart';

class OrdersUseCase extends BaseUseCase<List<OrderModel>, OrdersParams> {
  final AppRepository repository;

  OrdersUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<OrderModel>>> call(OrdersParams parameters) async {
    return await repository.getOrders(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<OrderModel>>> callTest(OrdersParams parameters) {
    throw UnimplementedError();
  }
}

class OrdersParams {
  final OrdersStatus ordersStatus;
  final bool typeIsProvider;
  OrdersParams(this.ordersStatus,this.typeIsProvider);
}

enum OrdersStatus { pending, cancelled, completed }
