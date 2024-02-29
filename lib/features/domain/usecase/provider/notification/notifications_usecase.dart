import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/notification/notification_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class NotificationsUseCase extends BaseUseCase<BaseResponse<List<NotificationModel>>, int> {
  final AppRepository repository;

  NotificationsUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse<List<NotificationModel>>>> call(int parameters) async {
    return await repository.getNotifications(parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse<List<NotificationModel>>>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
