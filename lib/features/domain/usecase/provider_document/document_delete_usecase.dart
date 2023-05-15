import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class DocumentDeleteUseCase extends BaseUseCase<BaseResponse, int> {
  final ProviderRepositoryProvider repository;

  DocumentDeleteUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(int parameters) async {
    return await repository.deleteDocument(id: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(int parameters) {
    throw UnimplementedError();
  }
}
