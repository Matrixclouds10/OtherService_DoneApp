import 'package:weltweit/features/data/models/base/base_model.dart';

import '../../../data/models/base/response_model.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import '../../repositoy/auth_repo.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_usecase.dart';

class LogoutUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<ResponseModel> call() async {
    return BaseUseCaseCall.onGetData<UserModel>(
        await repository.logout(), onConvert);
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    return ResponseModel(true, baseModel.message);
  }
}
