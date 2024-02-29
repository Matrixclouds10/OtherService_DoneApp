import 'package:weltweit/features/data/models/base/base_model.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_use_case_call.dart';
import 'package:weltweit/features/domain/usecase/auth/base_usecase/base_usecase.dart';

import '../../../data/models/base/response_model.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import '../../repositoy/auth_repo.dart';

class SignInUseCase implements BaseUseCase<UserModel> {
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<ResponseModel> call({required LoginParams loginBody, required bool typeIsProvider}) async {
    return BaseUseCaseCall.onGetData<UserModel>(
        await repository.login(
          loginBody: loginBody,
          typeIsProvider: typeIsProvider,
        ),
        onConvert,
        tag: 'SignInUseCase');
  }

  @override
  ResponseModel<UserModel> onConvert(BaseModel baseModel) {
    try {
      String? token = baseModel.responseData['token'];
      if (token != null) {
        UserModel user = UserModel.fromJson(baseModel.responseData);
        return ResponseModel(true, baseModel.message, data: user);
      } else {
        return ResponseModel(true, baseModel.message, data: baseModel.responseData);
      }
    } catch (e) {
      return ResponseModel(true, baseModel.message, data: baseModel.responseData);
    }
  }
}

class LoginParams {
  String? phone;
  CountryModel? countryModel;
  String? password;
  String? deviceToken;

  LoginParams({this.phone, this.countryModel, this.password, this.deviceToken});

  LoginParams copyWith({
    String? phone,
    CountryModel? countryModel,
    String? password,
    String? deviceToken,
  }) {
    return LoginParams(
      phone: phone ?? this.phone,
      countryModel: countryModel ?? this.countryModel,
      password: password ?? this.password,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile_number': phone,
      'country_id': countryModel?.id,
      'password': password,
      'fcm_token': deviceToken,
      'country_code': countryModel?.code ?? '20',
    };
  }
}
