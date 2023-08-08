import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/subscription/update_subscribtion_response.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class RePaySubscribeUseCase extends BaseUseCase<UpdateSubscribtionResponse, RePaySubscribeParams> {
  final AppRepositoryProvider repository;

  RePaySubscribeUseCase(this.repository);

  @override
  Future<Either<ErrorModel, UpdateSubscribtionResponse>> call(RePaySubscribeParams parameters) async {
    return await repository.rePaySubscribe(params: parameters);
  }

  @override
  Future<Either<ErrorModel, UpdateSubscribtionResponse>> callTest(RePaySubscribeParams parameters) {
    throw UnimplementedError();
  }
}

class RePaySubscribeParams {
  int id;
  String paymentMethod;

  RePaySubscribeParams({
    required this.id,
    required this.paymentMethod,
  });

  toJson() {
    return {
      'provider_subscription_id': id,
      'payment_method': paymentMethod.contains('visa') ? 'credit' : paymentMethod,
    };
  }
}
