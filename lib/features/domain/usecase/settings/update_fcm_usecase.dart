import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class UpdateFcmUseCase implements BaseUseCase<BaseResponse, String> {
  final AppRepository repository;

  UpdateFcmUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(String params) async {
    return await repository.updateFcm(fcmToken: params);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(String params) {
    throw UnimplementedError();
  }
}
