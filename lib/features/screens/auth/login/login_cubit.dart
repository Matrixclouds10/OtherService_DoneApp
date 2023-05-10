import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/notification/device_token.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/base/response_model.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/domain/usecase/auth/sign_in_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginlState> {
  final SignInUseCase _signInUseCase;

  LoginCubit({
    required SignInUseCase signInUseCase,
  })  : _signInUseCase = signInUseCase,
        super(LoginViewInitial());

  ///variables
  final LoginParams params = LoginParams();

  ///calling APIs Functions
  Future<ResponseModel> login(LoginParams loginBody, bool typeIsProvider) async {
    emit(LoginViewLoading());
    String? fcmToken;
    try {
      fcmToken = await getDeviceToken();
      loginBody.deviceToken = fcmToken;
    } catch (e) {
      log('login', ' fcmToken error: $e');
      emit(LoginViewError(error: null));
    }
    emit(LoginViewLoading());
    ResponseModel responseModel = await _signInUseCase(loginBody: loginBody, typeIsProvider: typeIsProvider);
    if (responseModel.isSuccess) {
      emit(LoginViewSuccessfully());
    } else {
      emit(LoginViewError(error: responseModel.error));
    }

    return responseModel;
  }
}
