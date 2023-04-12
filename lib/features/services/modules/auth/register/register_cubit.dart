import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/services/data/model/base/response_model.dart';
import 'package:weltweit/features/services/domain/request_body/register_body.dart';
import 'package:weltweit/features/services/domain/usecase/auth/register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final _tag = 'RegisterCubit';
  final RegisterUseCase _registerUseCase;

  RegisterCubit({
    required RegisterUseCase registerUseCase,
  })  : _registerUseCase = registerUseCase,
        super(RegisterInitial());

  ///colling api functions
  //register user
  Future<ResponseModel> register(RegisterBody body) async {
    emit(RegisterLoading());

    ResponseModel responseModel = await _registerUseCase.call(body: body);
    if (responseModel.isSuccess) {
      emit(RegisterSuccessfully());
    } else {
      emit(RegisterInitial());
    }

    return responseModel;
  }
}
