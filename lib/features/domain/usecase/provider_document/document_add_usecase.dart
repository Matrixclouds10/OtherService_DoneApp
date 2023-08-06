import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';

import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

class DocumentAddUseCase extends BaseUseCase<BaseResponse, DocumentParams> {
  final AppRepositoryProvider repository;

  DocumentAddUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, BaseResponse>> call(
      DocumentParams parameters) async {
    log('DocumentAddUseCase call');
    log('DocumentAddUseCase call ${parameters.toJson()}');
    log('DocumentAddUseCase call ${parameters.image.path}');

    return await repository.addDocument(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(DocumentParams parameters) {
    throw UnimplementedError();
  }
}

class DocumentParams {
  int? id;
  File image;
  DocumentType documentType;

  DocumentParams({this.id, required this.image, required this.documentType});

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': documentType.name,
    };
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last),
      'type': documentType.name,
      if (id != null) 'id': id,
    });
  }
}

enum DocumentType {
  national_id,
  work_certificate,
  corona_certificate,
  passport,
  others,
  others_2,
  others_3,
}
