import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/provider/data/models/response/documents/document.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';

class DocumentsUseCase extends BaseUseCase<List<Document>, NoParameters> {
  final AppRepositoryProvider repository;

  DocumentsUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, List<Document>>> call(NoParameters parameters) async {
    return await repository.getDocuments();
  }

  @override
  Future<Either<ErrorModel, List<Document>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}
