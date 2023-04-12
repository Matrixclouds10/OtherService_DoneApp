import 'package:weltweit/domain/request_body/contact_us_request_body.dart';

import '../../data/model/base/api_response.dart';

abstract class SettingRepository {
  Future<ApiResponse> getCities();
  Future<ApiResponse> getCategories();

  Future<ApiResponse> contactUsRequest(ContactUsRequestsBody body);
  Future<ApiResponse> getFQAs();
}
