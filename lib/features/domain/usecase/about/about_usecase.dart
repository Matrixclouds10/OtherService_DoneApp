import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class AboutUseCase extends BaseUseCase<String, NoParameters> {
  final AppRepository repository;

  AboutUseCase(this.repository);

  @override
  Future<Either<ErrorModel, String>> call(NoParameters parameters) async {
    final result =  await repository.getAbout();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<ErrorModel, String>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}

