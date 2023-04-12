import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../utils/constants.dart';
import '../local/cache_consumer.dart';
import '../local/storage_keys.dart';

const String _baseURL = "";
const String _apiKey = "";
const String _xApiKey = "x-api-key";
const String _contentType = "Content-Type";
const String _accept = "Accept";
const String _applicationJson = "application/json";
const String _authorization = "Authorization";

class ApiConsumer {
  final Dio _dio;
  final Interceptor _interceptor;
  final AppPrefs _cacheConsumer;

  ApiConsumer(this._dio, this._interceptor, this._cacheConsumer) {
    BaseOptions options = BaseOptions(
      baseUrl: _baseURL,
      receiveDataWhenStatusError: true,
      sendTimeout: Constants.connectTimeout,
      connectTimeout: Constants.connectTimeout,
      receiveTimeout: Constants.connectTimeout,
      headers: {
        _xApiKey: _apiKey,
        _contentType: _applicationJson,
        _accept: _applicationJson
      },
    );

    _dio.options = options;

    if (kDebugMode) {
      _dio.interceptors.add(_interceptor);
    }
  }

  Future<Response> post({
    required String url,
    required var data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(PrefKeys.token);
    return await _dio.post(
      url,
      queryParameters: queryParameters,
      data: data,
      options: Options(
        headers: {
          _authorization: token != null ? "Bearer $token" : Constants.empty
        },
      ),
    );
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(PrefKeys.token);
    return await _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          _authorization: token != null ? "Bearer $token" : Constants.empty
        },
      ),
    );
  }

  Future<Response> put({
    required String url,
    required var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(PrefKeys.token);
    return await _dio.put(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          _authorization: token != null ? "Bearer $token" : Constants.empty
        },
      ),
    );
  }

  Future<Response> delete({
    required String url,
    var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(PrefKeys.token);
    return await _dio.delete(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          _authorization: token != null ? "Bear $token" : Constants.empty
        },
      ),
    );
  }
}
