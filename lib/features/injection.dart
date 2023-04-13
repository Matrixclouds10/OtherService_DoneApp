import 'package:weltweit/features/data/repository/auth_repository_imp.dart';
import 'package:weltweit/features/domain/usecase/auth/update_fcm_token_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_availablity_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_location_usecase%20copy.dart';
import 'package:weltweit/features/services/domain/repository/auth_repo.dart';
import 'package:weltweit/features/domain/usecase/auth/check_otp_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/delete_account_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/forget_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/logout_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/register_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/reset_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/auth/sign_in_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/order/order_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/orders/orders_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/favorite/add_favorite/add_favorite_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/favorite/favorite_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/provider/services/services_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/provider/portfolio/portfolio_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/provider/provider/provider_usecase.dart';
import 'package:weltweit/core/services/network/network_client.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/services/data/repository/address_repository_imp.dart';
import 'package:weltweit/features/services/data/repository/app_repository_imp.dart';
import 'package:weltweit/features/services/domain/repository/address_repository.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_create_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_delete_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_read_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_update_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/delete_profile_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/profile_read_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/favorite/remove_favorite/remove_favorite_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/services/all_services_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/services/update_services_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/settings/update_fcm_usecase.dart';



Future<void> init() async {
  getIt.registerLazySingleton(() => NetworkClient());

  //* Auth
  getIt.registerLazySingleton(() => SignInUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ForgetPasswordUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => CheckOTPUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteAccountUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateFCMTokenUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(repository: getIt()));

  /* --------------------------------  Address ------------------------------- */
  //* Repository
  getIt.registerLazySingleton<AddressRepository>(() => AddressRepositoryImp(dioClient: getIt()));

  /// Repository
  getIt.registerLazySingleton<AppRepository>(() => AppRepositoryImp(networkClient: getIt()));

  //* Address
  getIt.registerLazySingleton(() => AddressReadUsecase(getIt()));
  getIt.registerLazySingleton(() => AddressCreateUsecase(getIt()));
  getIt.registerLazySingleton(() => AddressUpdateUsecase(getIt()));
  getIt.registerLazySingleton(() => AddressDeleteUsecase(getIt()));

  //Profile
  getIt.registerLazySingleton(() => UpdateProfileUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ProfileUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteProfileUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateProfileAvailabilityUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateProfileLocationUseCase(repository: getIt()));


  //Services
  getIt.registerLazySingleton(() => AllServicesUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateServicesUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ProvidersUseCase(repository: getIt()));

  //Settings
  getIt.registerLazySingleton(() => UpdateFcmUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ProviderUseCase(getIt()));
  getIt.registerLazySingleton(() => PortfolioUseCase(getIt()));
  getIt.registerLazySingleton(() => ProviderServicesUseCase(getIt()));
  getIt.registerLazySingleton(() => FavoriteUseCase(getIt()));
  getIt.registerLazySingleton(() => AddFavoriteUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveFavoriteUseCase(getIt()));
  getIt.registerLazySingleton(() => OrdersUseCase(getIt()));
  getIt.registerLazySingleton(() => OrderUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateOrderUseCase(getIt()));

  /// Repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(dioClient: getIt()));
}
