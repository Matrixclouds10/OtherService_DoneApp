
import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_add_usecase.dart';

class DocumentUpdateUseCase extends BaseUseCase<BaseResponse, DocumentParams> {
  final ProviderRepositoryProvider repository;

  DocumentUpdateUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(
      DocumentParams parameters) async {
    return await repository.updateDocument(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(DocumentParams parameters) {
    throw UnimplementedError();
  }
}
