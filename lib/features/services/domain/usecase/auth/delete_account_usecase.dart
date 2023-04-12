import 'package:weltweit/features/services/data/model/base/base_model.dart';

import '../../../data/model/base/response_model.dart';
import '../../../data/model/response/user_model.dart';
import '../../repository/auth_repo.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/services/domain/usecase/auth/base_usecase/base_usecase.dart';

class DeleteAccountUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  DeleteAccountUseCase({required this.repository});

  Future<ResponseModel> call() async {
    return BaseUseCaseCall.onGetData<UserModel>(
        await repository.deleteAccount(), onConvert);
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    return ResponseModel(true, baseModel.message);
  }
}
