import 'package:weltweit/data/model/base/base_model.dart';
import 'package:weltweit/domain/request_body/register_body.dart';

import '../../../../../data/model/base/response_model.dart';
import '../../../../../domain/repository/auth_repo.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_usecase.dart';

class RegisterUseCase implements BaseUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<ResponseModel> call({required RegisterBody body}) async {
    return BaseUseCaseCall.onGetData(
        await repository.register(registerBody: body), onConvert,
        tag: 'RegisterUseCase');
  }

  @override
  ResponseModel onConvert(BaseModel baseModel) {
    return ResponseModel(true, baseModel.message, data: baseModel.responseData);
  }
}
