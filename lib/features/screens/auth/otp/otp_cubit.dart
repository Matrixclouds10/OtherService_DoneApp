import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/notification/device_token.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/features/data/models/base/response_model.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/domain/usecase/auth/check_otp_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/forget_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/update_fcm_token_usecase.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final CheckOTPUseCase _otpUseCase;
  final UpdateFCMTokenUseCase _updateFCMTokenUseCase;

  OtpCubit({
    required CheckOTPUseCase otpUseCase,
    required ForgetPasswordUseCase forgetPasswordUseCase,
    required UpdateFCMTokenUseCase updateFCMTokenUseCase,
  })  : _forgetPasswordUseCase = forgetPasswordUseCase,
        _otpUseCase = otpUseCase,
        _updateFCMTokenUseCase = updateFCMTokenUseCase,
        super(OtpState());

  ///variables
  bool _isLoading = false;
  bool _isResendLoading = false;
  bool _isTimerDone = false;
  DateTime _endTime = DateTime.now().add(const Duration(minutes: 1));

  ///getters
  bool get isLoading => _isLoading;
  bool get isResendLoading => _isResendLoading;
  bool get isTimerDone => _isTimerDone;
  DateTime get endTime => _endTime;

  onTimerEnd() {
    _isTimerDone = true;
    emit(OtpState());
  }

  //TODO call API
  //send phone to get code
  Future<ResponseModel> reSendCode({required String email,required bool typeIsProvider}) async {
    if (!_isTimerDone) return ResponseModel(false, tr(LocaleKeys.error));
    _isResendLoading = true;
    emit(OtpState());
    ResponseModel responseModel = await _forgetPasswordUseCase.call(
      email: email,
      typeIsProvider: typeIsProvider,);

    if (responseModel.isSuccess) {
      _isTimerDone = false;
      _endTime = DateTime.now().add(const Duration(minutes: 1));
    }
    _isResendLoading = false;
    emit(OtpState());
    return responseModel;
  }
  Future<ResponseModel> reSendCodeNoState({required String email,required bool typeIsProvider}) async {
    emit(OtpState());
    ResponseModel responseModel = await _forgetPasswordUseCase.call(
      email: email,
      typeIsProvider: typeIsProvider,);
    return responseModel;
  }

  //send phone to get code
  Future<ResponseModel> otpCode({required String email, required String code, required String otp, required CheckOTPType type, required bool typeIsProvider}) async {
    _isLoading = true;
    emit(OtpState());
    ResponseModel responseModel = await _otpUseCase.call(
        body: CheckOTPBody(
      email: email,
      code: code,
      type: type,
      otp: otp,
      typeIsProvider: typeIsProvider,
    ));
    if (type == CheckOTPType.register && responseModel.isSuccess && responseModel.data != null) {
      UserModel userEntity = responseModel.data;
      String token = userEntity.token ?? '';
      int id = userEntity.id ?? 0;
      kEcho("countryId ${userEntity.countryModel?.id}");
      int countryId = userEntity.countryId ?? userEntity.countryModel?.id ?? 0;
      AppPrefs prefs = getIt();
      prefs.save(PrefKeys.token, token);
      if (countryId != 0) prefs.save(PrefKeys.countryId, countryId);
      prefs.save(PrefKeys.id, id);
      prefs.save(PrefKeys.isTypeProvider, typeIsProvider);
    }
    _isLoading = false;
    emit(OtpState());
    return responseModel;
  }

  Future<void> _updateFCMToken() async {
    String? fcmToken = await getDeviceToken();
    if (fcmToken == null) {
      return;
    }
    await _updateFCMTokenUseCase.call(fcmToken: fcmToken);
    emit(OtpState());
  }
}
