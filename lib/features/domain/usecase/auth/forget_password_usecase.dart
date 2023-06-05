import 'package:weltweit/features/data/models/base/base_model.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_usecase.dart';

import '../../../data/models/base/response_model.dart';
import '../../repositoy/auth_repo.dart';

class ForgetPasswordUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  ForgetPasswordUseCase({required this.repository});

  Future<ResponseModel> call({required String email}) async {
    return BaseUseCaseCall.onGetData<UserModel>(await repository.forgetPassword(email: email), onConvert);
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    return ResponseModel(true, baseModel.message);
  }

  Future<ResponseModel> callTest({required String phone}) async {
    return ResponseModel(true, '');
  }
}
