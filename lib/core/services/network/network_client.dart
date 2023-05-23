import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/data/datasource/remote/dio/dio_client.dart';
import 'package:weltweit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/base/base_response.dart';

class NetworkClient {
  Future<Either<ErrorModel, BaseResponse>> call({
    required Map<String, dynamic> data,
    required String url,
    required NetworkCallType type,
    FormData? formData,
  }) async {
    DioClient dioClient = getIt<DioClient>();
    late Response response;
    AppPrefs prefs = getIt();
    String lang = await prefs.get(PrefKeys.lang, defaultValue: "ar");

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': lang,
        'User-Agents': 'android', //TODO change this
      },
    );
    String? token = await prefs.getSecuredData(PrefKeys.token);
    token ??= await prefs.get(PrefKeys.token);
    if (token != null) {
      options.headers?.addAll({'Authorization': 'Bearer $token'});
    }
    data.forEach((key, value) {
      log('data $key', '$value');
    });
    if (formData != null) {
      for (var element in formData.files) {
        log('form data ${element.key}', element.value.filename ?? 'null');
      }
    }
    try {
      switch (type) {
        case NetworkCallType.get:
          response = await dioClient.get(url, queryParameters: data, options: options);
          break;
        case NetworkCallType.post:
          response = await dioClient.post(url, queryParameters: data, data: formData, ignorePath: true, options: options);
          break;
        case NetworkCallType.put:
          response = await dioClient.put(url, data: data, options: options);
          break;
        case NetworkCallType.delete:
          response = await dioClient.delete(url, data: data, options: options);
          break;
      }
      logger.i('response ${response.data}');

      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code != 200 || baseResponse.code != 201) {
        return Right(baseResponse);
      }
      if (response.data == null) {
        return Left(ErrorModel(errorMessage: baseResponse.message));
      }

      return Right(baseResponse);
    } catch (e) {
      log('network client error', e.toString());
      if (e is ErrorModel) return Left(e);
      return Left(ApiErrorHandler.getMessage(e));
    }
  }
}

enum NetworkCallType { get, post, put, delete }
