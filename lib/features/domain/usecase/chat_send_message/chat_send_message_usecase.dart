import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class ChatSendMessageUseCase extends BaseUseCase<BaseResponse, ChatSendMessageParams> {
  final AppRepository repository;

  ChatSendMessageUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(ChatSendMessageParams parameters) async {
    return await repository.sendChatMessage(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(ChatSendMessageParams parameters) {
    throw UnimplementedError();
  }
}

class ChatSendMessageParams {
  int id;
  String message;
  String? lat;
  String? lng;
  String? image;

  ChatSendMessageParams({
    required this.id,
    required this.message,
    this.lat,
    this.lng,
    this.image,
  });

  toJson() {
    return {
      'service_order_id': id,
      'message': image != null ? 'image' : message,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }

  toJsonFormData() async {
    return FormData.fromMap({
      if (image != null) 'image': await MultipartFile.fromFile(image!, filename: 'image'),
    });
  }
}
