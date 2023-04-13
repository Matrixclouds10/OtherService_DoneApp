import 'package:weltweit/features/data/models/base/base_model.dart';
import 'package:weltweit/features/services/domain/request_body/login_body.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_usecase.dart';

import '../../../data/models/base/response_model.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import '../../repositoy/auth_repo.dart';

class SignInUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<ResponseModel> call({required LoginBody loginBody,required  bool typeIsProvider}) async {
    return BaseUseCaseCall.onGetData<UserModel>(
        await repository.login(
          loginBody: loginBody,
          typeIsProvider: typeIsProvider,
        ),
        onConvert,
        tag: 'SignInUseCase');
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
