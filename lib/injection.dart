import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/services/modules/auth/otp/otp_cubit.dart';
import 'package:weltweit/features/services/modules/auth/register/register_cubit.dart';

import 'features/services/modules/auth/login/login_cubit.dart';

Future<void> init() async {
  // Bloc
  getIt.registerLazySingleton(() => LoginCubit(signInUseCase: getIt()));
  getIt.registerLazySingleton(() => RegisterCubit(registerUseCase: getIt()));

  getIt.registerLazySingleton(() => OtpCubit(forgetPasswordUseCase: getIt(), otpUseCase: getIt(), updateFCMTokenUseCase: getIt()));
}
