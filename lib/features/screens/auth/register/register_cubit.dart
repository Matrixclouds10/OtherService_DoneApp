import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/data/models/base/response_model.dart';
import 'package:weltweit/features/domain/request_body/register_body.dart';
import 'package:weltweit/features/domain/usecase/auth/register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
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
