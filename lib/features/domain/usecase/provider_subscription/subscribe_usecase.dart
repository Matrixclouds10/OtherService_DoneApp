import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class SubscribeUseCase extends BaseUseCase<BaseResponse, SubscribeParams> {
  final AppRepositoryProvider repository;

  SubscribeUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(SubscribeParams parameters) async {
    return await repository.subscribe(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(SubscribeParams parameters) {
    throw UnimplementedError();
  }
}

class SubscribeParams {
  int id;
  String paymentMethod;

  SubscribeParams({
    required this.id,
    required this.paymentMethod,
  });

  toJson() {
    return {
      'subscription_id': id,
      'payment_method': paymentMethod,
    };
  }
}
