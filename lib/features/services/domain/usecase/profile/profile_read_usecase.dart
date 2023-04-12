import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';
import 'package:weltweit/features/services/core/base/base_usecase.dart';

class ProfileUseCase extends BaseUseCase<UserModel, NoParameters> {
  final AppRepository repository;

  ProfileUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, UserModel>> call(NoParameters parameters) async {
    return await repository.getProfile();
  }

  @override
  Future<Either<ErrorModel, UserModel>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}
