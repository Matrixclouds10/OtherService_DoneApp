import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';

class UpdateProfileAvailabilityUseCase
    implements BaseUseCase<UserModel, NoParameters> {
  final AppRepository repository;

  UpdateProfileAvailabilityUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, UserModel>> call(NoParameters parameters) async {
    return await repository.updateAvailability();
  }

  @override
  Future<Either<ErrorModel, UserModel>> callTest(NoParameters params) {
    throw UnimplementedError();
  }
}
