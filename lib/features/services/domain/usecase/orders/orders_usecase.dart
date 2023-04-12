import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import '../../../core/base/base_usecase.dart';
import '../../repository/app_repo.dart';

class OrdersUseCase extends BaseUseCase<List<OrderModel>, NoParameters> {
  final AppRepository repository;

  OrdersUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<OrderModel>>> call(NoParameters parameters) async {
    return await repository.getOrders(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<OrderModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}
