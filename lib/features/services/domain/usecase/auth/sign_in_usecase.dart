import 'package:weltweit/features/services/data/model/base/base_model.dart';
import 'package:weltweit/features/services/domain/request_body/login_body.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_usecase.dart';

import '../../../data/model/base/response_model.dart';
import '../../../data/model/response/user_model.dart';
import '../../repository/auth_repo.dart';

class SignInUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<ResponseModel> call({required LoginBody loginBody}) async {
    return BaseUseCaseCall.onGetData<UserModel>(await repository.login(loginBody: loginBody), onConvert, tag: 'SignInUseCase');
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    try {
      String? token = baseModel.responseData['token'];
      if (token != null) {
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
