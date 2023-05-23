import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/network/api_consumer.dart';
import 'package:weltweit/core/utils/globals.dart';
import 'package:weltweit/data/datasource/remote/dio/dio_client.dart';
import 'package:weltweit/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:weltweit/features/data/repository/provider_repository_imp.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';
import 'package:weltweit/features/domain/usecase/provider/notification/notifications_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider/notification/provider_notifications_usecase.dart';
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

final getIt = GetIt.instance;

Future<void> init() async {


  /// Core
  getIt.registerLazySingleton(() => DioClient("", getIt(), loggingInterceptor: getIt(), cacheConsumer: getIt()));


  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => LoggingInterceptor());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => AppPrefs(secureStorage: getIt(), sharedPreferences: getIt()));

  getIt.registerLazySingleton<PrettyDioLogger>(() => PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));
  getIt.registerLazySingleton(() => ApiConsumer(getIt<Dio>(), getIt<PrettyDioLogger>(), getIt()));

  
  getIt.registerLazySingleton(() => GlobalParams());
  // Bloc
  getIt.registerLazySingleton(() => LoginCubit(signInUseCase: getIt()));
  getIt.registerLazySingleton(() => RegisterCubit(registerUseCase: getIt()));

  getIt.registerLazySingleton(() => OtpCubit(forgetPasswordUseCase: getIt(), otpUseCase: getIt(), updateFCMTokenUseCase: getIt()));



  //*Provider

  getIt.registerLazySingleton<AppRepositoryProvider>(() => ProviderRepositoryImpProvider(networkClient: getIt()));

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


  //Notification
  getIt.registerLazySingleton(() => NotificationsUseCase(getIt()));
  getIt.registerLazySingleton(() => ProviderNotificationsUseCase(getIt()));
  
/* -------------------------------------------------------------------------- */
}
