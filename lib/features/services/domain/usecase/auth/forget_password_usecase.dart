import 'package:weltweit/features/services/data/model/base/base_model.dart';

import '../../../data/model/base/response_model.dart';
import '../../../data/model/response/user_model.dart';
import '../../repository/auth_repo.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_usecase.dart';

class ForgetPasswordUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  ForgetPasswordUseCase({required this.repository});

  Future<ResponseModel> call({required String phone}) async {
    return BaseUseCaseCall.onGetData<UserModel>(
        await repository.forgetPassword(phone: phone), onConvert);
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    return ResponseModel(true, baseModel.message);
  }

  Future<ResponseModel> callTest({required String phone}) async {
    return ResponseModel(true, '');
  }
}
