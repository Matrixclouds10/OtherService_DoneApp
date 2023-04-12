import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/core/base/base_response.dart';
import 'package:weltweit/features/services/core/base/base_usecase.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';

class ChangePasswordUseCase
    implements BaseUseCase<BaseResponse, ChangePasswordParams> {
  final AppRepository repository;

  ChangePasswordUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(
      ChangePasswordParams params) async {
    return await repository.changePassword(params: params);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(
      ChangePasswordParams params) {
    throw UnimplementedError();
  }
}

class ChangePasswordParams {
  final String newPassword;

  ChangePasswordParams({required this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      'password': newPassword,
    };
  }
}
