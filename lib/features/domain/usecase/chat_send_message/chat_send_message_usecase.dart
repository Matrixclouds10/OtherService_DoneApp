import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';

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

  ChatSendMessageParams({
    required this.id,
    required this.message,
  });

  toJson() {
    return {
      'service_order_id': id,
      'message': message,
    };
  }
}

