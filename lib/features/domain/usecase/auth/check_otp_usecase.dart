import 'package:logger/logger.dart';
import 'package:weltweit/features/data/models/base/base_model.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';

import '../../repositoy/auth_repo.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_usecase.dart';
import 'package:weltweit/features/data/models/base/response_model.dart';

class CheckOTPUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;
  CheckOTPUseCase({required this.repository});
  Future<ResponseModel> call({required CheckOTPBody body}) async {
    return BaseUseCaseCall.onGetData<UserModel>(await repository.otpCode(checkOTPBody: body), onConvert);
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    try {
      String? token = baseModel.responseData['token'];
      if (token != null) {
        Logger().i('token: $token');
        Logger().i('token: ${baseModel.responseData}');
        UserModel user = UserModel.fromJson(baseModel.responseData);
        return ResponseModel(true, baseModel.message, data: user);
      } else {
        return ResponseModel(true, baseModel.message, data: baseModel.responseData);
      }
    } catch (e) {
      return ResponseModel(true, baseModel.message, data: baseModel.responseData);
    }
  }
}
