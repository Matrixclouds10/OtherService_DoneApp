import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weltweit/data/repository/auth_repository_imp.dart';

import 'package:weltweit/data/repository/notification_repository_imp.dart';
import 'package:weltweit/data/repository/setting_repository_imp.dart';
import 'package:weltweit/domain/repository/auth_repo.dart';
import 'package:weltweit/domain/repository/notification_repo.dart';
import 'package:weltweit/domain/repository/setting_repo.dart';

import '../core/services/local/cache_consumer.dart';
import '../core/services/network/api_consumer.dart';

import '../domain/repository/local_repo.dart';
import '../domain/repository/offer_repo.dart';
import 'app_urls/app_url.dart';
import 'datasource/remote/dio/dio_client.dart';
import 'datasource/remote/dio/logging_interceptor.dart';
import 'repository/local_repository_imp.dart';
import 'repository/offer_repository_imp.dart';

final getIt = GetIt.instance;
Future<void> init() async {
  /// Core
  getIt.registerLazySingleton(() => DioClient(AppURL.kBaseURL, getIt(),
      loggingInterceptor: getIt(), cacheConsumer: getIt()));

  /// Repository
  getIt.registerLazySingleton<LocalRepository>(
      () => LocalRepositoryImp(dioClient: getIt(), cacheConsumer: getIt()));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImp(dioClient: getIt()));
  getIt.registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImp(dioClient: getIt()));
  getIt.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImp(dioClient: getIt()));
  getIt.registerLazySingleton<OfferRepository>(
      () => OfferRepositoryImp(dioClient: getIt()));

  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => LoggingInterceptor());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(
      () => AppPrefs(secureStorage: getIt(), sharedPreferences: getIt()));

  getIt.registerLazySingleton<PrettyDioLogger>(
    () => PrettyDioLogger(
        requestHeader: true, requestBody: true, responseHeader: true),
  );
  getIt.registerLazySingleton(
      () => ApiConsumer(getIt<Dio>(), getIt<PrettyDioLogger>(), getIt()));
}
