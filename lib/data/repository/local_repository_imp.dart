import 'package:weltweit/domain/logger.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../app.dart';
import '../../core/services/local/cache_consumer.dart';
import '../../core/services/local/storage_keys.dart';
import '../../domain/repository/local_repo.dart';
import '../app_urls/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';

class LocalRepositoryImp implements LocalRepository {
  final DioClient? _dioClient;
  final AppPrefs _cacheConsumer;

  LocalRepositoryImp({
    required DioClient? dioClient,
    required AppPrefs cacheConsumer,
  })  : _dioClient = dioClient,
        _cacheConsumer = cacheConsumer;

  // for  user token
  @override
  Future<bool> saveSecuredData(String token) async {
    await _cacheConsumer.saveSecuredData(PrefKeys.token, token);
    log('saveSecuredData', 'token :$token');
    _dioClient!.token = token;
    _dioClient!.dio!.options.headers = {
      'Accept': 'application/json; charset=UTF-8',
      'x-api-key': AppURL.kAPIKey,
      'Content-Language': appContext?.locale.languageCode ?? 'en',
      'Authorization': 'Bearer $token'
    };

    return await _cacheConsumer.save(PrefKeys.isAuthed, true);
  }

  @override
  Future<String> getUserToken() async {
    return await _cacheConsumer.getSecuredData(PrefKeys.token) ?? '';
  }

  @override
  bool isLoggedIn() {
    return _cacheConsumer.get(PrefKeys.isAuthed) ?? false;
  }

  @override
  Future<bool> clearSharedData() async {
    _cacheConsumer.deleteSecuredData();
    _cacheConsumer.delete(PrefKeys.isAuthed);
    return _cacheConsumer.delete(PrefKeys.token);
  }
}
