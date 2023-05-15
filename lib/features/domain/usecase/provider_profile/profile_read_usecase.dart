import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';

import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';
class ProfileProviderUseCase extends BaseUseCase<UserModel, NoParameters> {
  final ProviderRepositoryProvider repository;

  ProfileProviderUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, UserModel>> call(NoParameters parameters) async {
    return await repository.getProfile();
  }

  @override
  Future<Either<ErrorModel, UserModel>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}
