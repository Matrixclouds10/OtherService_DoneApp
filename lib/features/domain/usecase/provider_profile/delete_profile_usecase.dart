import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';
class DeleteProfileProviderUseCase implements BaseUseCase<bool, int> {
  final AppRepositoryProvider repository;

  DeleteProfileProviderUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, bool>> call(int id) async {
    return await repository.deleteProfile(id: id);
  }

  @override
  Future<Either<ErrorModel, bool>> callTest(int id) {
    throw UnimplementedError();
  }
}
