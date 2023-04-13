import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import '../../../../core/base/base_usecase.dart';
import '../../repository/app_repo.dart';

class CreateOrderUseCase extends BaseUseCase<OrderModel, CreateOrderParams> {
  final AppRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<ErrorModel, OrderModel>> call(CreateOrderParams parameters) async {
    return await repository.createOrder(params: parameters);
  }

  @override
  Future<Either<ErrorModel, OrderModel>> callTest(CreateOrderParams parameters) {
    throw UnimplementedError();
  }
}

class CreateOrderParams {
  //file date service_id provider_id
  final File? file;
  final String date;
  final int serviceId;
  final int providerId;

  CreateOrderParams({
    required this.file,
    required this.date,
    required this.serviceId,
    required this.providerId,
  });

  toJson() {
    return {
      'date': date,
      'service_id': serviceId,
      'provider_id': providerId,
    };
  }
}
