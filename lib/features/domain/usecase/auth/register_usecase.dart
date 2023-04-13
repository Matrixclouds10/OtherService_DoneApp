import 'package:weltweit/features/data/models/base/base_model.dart';
import 'package:weltweit/features/services/domain/request_body/register_body.dart';

import '../../../data/models/base/response_model.dart';
import '../../repositoy/auth_repo.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_usecase.dart';

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
