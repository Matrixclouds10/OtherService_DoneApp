import 'package:weltweit/features/data/models/base/base_model.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_usecase.dart';

import '../../../../data/datasource/remote/exception/api_checker.dart';
import '../../../data/models/base/response_model.dart';
import '../../repositoy/auth_repo.dart';

class ResetPasswordUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  Future<ResponseModel> call({required String email, required String password}) async {
    return BaseUseCaseCall.onGetData<UserModel>(await repository.resetPassword(email: email, password: password), onConvert);
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
