import '../../data/model/base/api_response.dart';

abstract class ChatRepository {
  Future<ApiResponse> getUserChats();
  Future<ApiResponse> getChatDetails({required int chatId});
}
