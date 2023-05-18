import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/subscription/subscription_history_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class SubscribtionHistoryUseCase extends BaseUseCase<List<SubscriptionHistoryModel>, NoParameters> {
  final ProviderRepositoryProvider repository;

  SubscribtionHistoryUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<SubscriptionHistoryModel>>> call(NoParameters parameters) async {
    return await repository.getSubscriptionHistory();
  }

  @override
  Future<Either<ErrorModel, List<SubscriptionHistoryModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

