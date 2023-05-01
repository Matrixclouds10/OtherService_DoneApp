import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/data/models/response/chat/chat_model.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';

class ChatMessagesUseCase extends BaseUseCase<List<ChatModel>, ChatMessagesParams> {
  final AppRepository repository;

  ChatMessagesUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<ChatModel>>> call(ChatMessagesParams parameters) async {
    return await repository.getChatMessages(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<ChatModel>>> callTest(ChatMessagesParams parameters) {
    throw UnimplementedError();
  }
}

class ChatMessagesParams {
  int id;

  ChatMessagesParams({
    required this.id,
  });

  toJson() {
    return {
      'service_order_id': id,
    };
  }
}
