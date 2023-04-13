
import 'package:weltweit/features/data/models/base/api_response.dart';
import 'package:weltweit/features/provider/domain/request_body/profile_body.dart';


abstract class ProfileRepository {
  Future<ApiResponse> getProfile();
  Future<ApiResponse> updateProfile({required ProfileBody profileBody});
}
