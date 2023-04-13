import 'package:weltweit/features/provider/domain/usecase/document/document_add_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/document/document_delete_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/document/document_update_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/document/documents_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_add_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_delete_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_update_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolios_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/all_services_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/my_services_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/update_services_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/settings/update_fcm_usecase.dart';

import '../data/injection.dart';

Future<void> init() async {
  



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
  getIt.registerLazySingleton(() => UpdateFcmUseCase(repository: getIt()));

  //Services
}
