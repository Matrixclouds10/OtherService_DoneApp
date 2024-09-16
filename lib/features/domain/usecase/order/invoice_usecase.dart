import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/order/invoice.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class InvoiceUseCase extends BaseUseCase<InvoiceModel, int> {
  final AppRepository repository;

  InvoiceUseCase(this.repository);

  @override
  Future<Either<ErrorModel, InvoiceModel>> call(int parameters) async {
    return await repository.getInvoiceOrder(id: parameters);
  }

  @override
  Future<Either<ErrorModel, InvoiceModel>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
