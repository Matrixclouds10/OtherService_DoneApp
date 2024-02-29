import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/documents/hiring_document_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class HiringDocumentsUseCase extends BaseUseCase<List<HiringDocumentModel>, NoParameters> {
  final AppRepositoryProvider repository;

  HiringDocumentsUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, List<HiringDocumentModel>>> call(NoParameters parameters) async {
    return await repository.getHiringDocuments();
  }

  @override
  Future<Either<ErrorModel, List<HiringDocumentModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}
