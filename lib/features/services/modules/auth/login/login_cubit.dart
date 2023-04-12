import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/notification/device_token.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/model/base/response_model.dart';
import 'package:weltweit/data/model/response/user_model.dart';
import 'package:weltweit/domain/logger.dart';
import 'package:weltweit/domain/request_body/login_body.dart';
import 'package:weltweit/features/services/domain/usecase/auth/sign_in_usecase.dart';
import 'package:weltweit/presentation/component/inputs/phone_country/countries.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginlState> {
  final SignInUseCase _signInUseCase;

  LoginCubit({
    required SignInUseCase signInUseCase,
  })  : _signInUseCase = signInUseCase,
        super(LoginViewInitial());

  ///variables
  final LoginBody _body = LoginBody(phone: "", password: "", deviceToken: '');

  ///getters
  LoginBody get body => _body;

  onCountryCode(Country country) {
    _body.updateCode(country.dialCode);
    emit(state);
  }

  ///calling APIs Functions
  Future<ResponseModel> login(String phone, String password) async {
    emit(LoginViewLoading());
    String? fcmToken;
    try {
      fcmToken = await getDeviceToken();
    } catch (e) {
      log('login', ' fcmToken error: $e');
      emit(LoginViewError(error: null));
    }
    emit(LoginViewLoading());

    _assignLoginBody(phone, password, fcmToken ?? '');
    ResponseModel responseModel = await _signInUseCase.call(loginBody: body);
    if (responseModel.isSuccess) {
      UserModel userEntity = responseModel.data;

      emit(LoginViewSuccessfully());
    } else {
      emit(LoginViewError(error: responseModel.error));
    }

    return responseModel;
  }

  void _assignLoginBody(String userName, String password, String fcmToken) {
    body.setData(phone: userName, password: password, deviceToken: fcmToken);
  }
}
