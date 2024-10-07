import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/subscription/subscription_history_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class SubscribtionHistoryUseCase extends BaseUseCase<SubscriptionHistoryAllData, NoParameters> {
  final AppRepositoryProvider repository;

  SubscribtionHistoryUseCase(this.repository);

  @override
  Future<Either<ErrorModel, SubscriptionHistoryAllData>> call(NoParameters parameters) async {
    return await repository.getSubscriptionHistory();
  }

  @override
  Future<Either<ErrorModel, SubscriptionHistoryAllData>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

