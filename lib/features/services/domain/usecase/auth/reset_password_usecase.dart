import 'package:weltweit/data/model/base/base_model.dart';

import '../../../../../data/datasource/remote/exception/api_checker.dart';
import '../../../../../data/model/base/response_model.dart';
import '../../../../../data/model/response/user_model.dart';
import '../../../../../domain/repository/auth_repo.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_usecase.dart';


class ResetPasswordUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  Future<ResponseModel> call(
      {required String phone, required String password}) async {
    return BaseUseCaseCall.onGetData<UserModel>(
        await repository.resetPassword(phone: phone, password: password),
        onConvert);
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    String? token = baseModel.responseData['auth']['token'];
    if (token != null) {
      UserModel? user = UserModel.fromJson(baseModel.responseData);
      return ResponseModel(true, baseModel.message, data: user);
    } else {
      return ApiChecker.checkApi(message: baseModel.message);
    }
  }
}
