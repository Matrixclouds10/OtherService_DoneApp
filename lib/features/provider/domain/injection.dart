import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/provider/data/repository/app_repository_imp.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';
import 'package:weltweit/features/provider/domain/usecase/document/document_add_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/document/document_delete_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/document/document_update_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/document/documents_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_add_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_delete_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_update_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolios_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/delete_profile_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/profile_read_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_fcm_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_profile_availablity_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_profile_location_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/all_services_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/my_services_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/update_services_usecase.dart';


Future<void> init() async {
  
  getIt.registerLazySingleton<AppRepositoryProvider>(() => AppRepositoryImpProvider(networkClient: getIt()));



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

  //Services
}
