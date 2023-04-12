import '../../data/model/base/api_response.dart';

abstract class NotificationRepository {
  Future<ApiResponse> getNotifications();
}
