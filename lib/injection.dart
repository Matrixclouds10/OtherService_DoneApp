import 'package:weltweit/core/utils/globals.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/data/repository/provider_repository_imp.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';
import 'package:weltweit/features/screens/auth/login/login_cubit.dart';
import 'package:weltweit/features/screens/auth/otp/otp_cubit.dart';
import 'package:weltweit/features/screens/auth/register/register_cubit.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_add_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_delete_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_update_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_document/documents_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolio_add_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolio_delete_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolio_update_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolios_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/delete_profile_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/profile_read_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_fcm_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_profile_availablity_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_profile_location_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_profile_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_services/all_services_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_services/my_services_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_services/update_services_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_wallet/wallet_history_usecase.dart';

Future<void> init() async {
  getIt.registerLazySingleton(() => GlobalParams());
  // Bloc
  getIt.registerLazySingleton(() => LoginCubit(signInUseCase: getIt()));
  getIt.registerLazySingleton(() => RegisterCubit(registerUseCase: getIt()));

  getIt.registerLazySingleton(() => OtpCubit(forgetPasswordUseCase: getIt(), otpUseCase: getIt(), updateFCMTokenUseCase: getIt()));



  //*Provider

  getIt.registerLazySingleton<ProviderRepositoryProvider>(() => ProviderRepositoryImpProvider(networkClient: getIt()));

  //Profile
  getIt.registerLazySingleton(() => UpdateProfileProviderUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ProfileProviderUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateProfileAvailabilityProviderUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ChangePasswordProviderUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteProfileProviderUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateProfileLocationProviderUseCase(repository: getIt()));


  //Documents
  getIt.registerLazySingleton(() => DocumentAddUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DocumentUpdateUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DocumentDeleteUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DocumentsUseCase(repository: getIt()));

  //Portfolio
  getIt.registerLazySingleton(() => PortfolioAddUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => PortfolioUpdateUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => PortfolioDeleteUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => PortfoliosUseCase(repository: getIt()));

  //Services
  getIt.registerLazySingleton(() => AllServicesUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => MyServicesUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateServicesUseCase(repository: getIt()));

  //Settings
  getIt.registerLazySingleton(() => UpdateFcmProviderUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => WalletHistoryUseCase(repository: getIt()));

/* -------------------------------------------------------------------------- */
}
