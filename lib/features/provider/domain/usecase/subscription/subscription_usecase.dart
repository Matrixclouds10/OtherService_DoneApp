import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/provider/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';

class SubscriptionUseCase extends BaseUseCase<List<SubscriptionModel>, NoParameters> {
  final AppRepositoryProvider repository;

  SubscriptionUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<SubscriptionModel>>> call(NoParameters parameters) async {
    return await repository.getSubscription();
  }

  @override
  Future<Either<ErrorModel, List<SubscriptionModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

