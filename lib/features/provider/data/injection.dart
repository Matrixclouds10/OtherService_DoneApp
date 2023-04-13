import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/network/api_consumer.dart';
import 'package:weltweit/core/services/network/network_client.dart';
import 'package:weltweit/data/datasource/remote/dio/dio_client.dart';
import 'package:weltweit/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:weltweit/features/provider/data/repository/app_repository_imp.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';

import 'app_urls/app_url.dart';

final getIt = GetIt.instance;
Future<void> init() async {
  /// Core
  getIt.registerLazySingleton(() => DioClient(AppURL.kBaseURL, getIt(), loggingInterceptor: getIt(), cacheConsumer: getIt()));

  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => LoggingInterceptor());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => AppPrefs(secureStorage: getIt(), sharedPreferences: getIt()));

  getIt.registerLazySingleton<PrettyDioLogger>(() => PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));
  getIt.registerLazySingleton(() => ApiConsumer(getIt<Dio>(), getIt<PrettyDioLogger>(), getIt()));
  getIt.registerLazySingleton(() => NetworkClient());

  /// Repository
  getIt.registerLazySingleton<AppRepository>(() => AppRepositoryImp(networkClient: getIt()));
}
