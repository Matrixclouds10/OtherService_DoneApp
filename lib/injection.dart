import 'package:weltweit/core/utils/globals.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/screens/auth/login/login_cubit.dart';
import 'package:weltweit/features/screens/auth/otp/otp_cubit.dart';
import 'package:weltweit/features/screens/auth/register/register_cubit.dart';

Future<void> init() async {
  getIt.registerLazySingleton(() => GlobalParams());
  // Bloc
  getIt.registerLazySingleton(() => LoginCubit(signInUseCase: getIt()));
  getIt.registerLazySingleton(() => RegisterCubit(registerUseCase: getIt()));

  getIt.registerLazySingleton(() => OtpCubit(forgetPasswordUseCase: getIt(), otpUseCase: getIt(), updateFCMTokenUseCase: getIt()));
}
