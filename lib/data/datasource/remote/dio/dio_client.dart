import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';

import '../../../../app.dart';
import '../../../../core/services/local/cache_consumer.dart';
import '../../../../core/services/local/storage_keys.dart';
import '../../../../domain/logger.dart';
import '../../../app_urls/app_url.dart';
import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final AppPrefs cacheConsumer;

  Dio? dio;
  String? token;

  _getToken() async {
    if (token == null) {
      token = await cacheConsumer.getSecuredData(PrefKeys.token);
      if (null != token) {
        dio?.options.headers.addAll({'Authorization': 'Bearer $token'});
      }
    }
  }

  DioClient(
    this.baseUrl,
    Dio? dioC, {
    required this.loggingInterceptor,
    required this.cacheConsumer,
  }) {
    dio = dioC ?? Dio();
    _getToken();
    dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..httpClientAdapter
      ..options.headers = {
        'Accept': 'application/json; charset=UTF-8',
        'x-api-key': AppURL.kAPIKey,
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': appContext?.locale.languageCode ?? 'ar',
        // 'Authorization': 'Bearer $token',
      };
    dio!.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    // queryParameters?.addAll({'token':token});
    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      Logger().d(response.data);
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? parameters,
    Options? options,
    String? filePath,
    bool ignorePath = false,
    List<String>? filePathList,
    String? filePathListName,
    List<FileModel>? filePathNamedList,
    String? fileName,
    List<FileModel>? filesPath,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (data != null)
        data.files.forEach((element) {
          Logger().d(element.value);
        });

      // if (!ignorePath) {
      //   data = await _buildFileData(
      //     filePath: filePath,
      //     filesPath: filesPath,
      //     filePathList: filePathList,
      //     filePathListName: filePathListName,
      //     fileName: fileName,
      //   );
      // }

      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      Logger().d(response.data);
      return response;
    } on FormatException catch (_) {
      log('post', 'Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      // log('post::', e.toString());

      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      Logger().d(response.data);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      Logger().d(response.data);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}

Future<FormData?> _buildFileData({
  required String? filePath,
  required List<FileModel>? filesPath,
  required List<String>? filePathList,
  required String? filePathListName,
  required String? fileName,
}) async {
  FormData? data;

  if (filePath != null) {
    String fName = filePath.split('/').last;
    Map<String, dynamic> body = {
      fileName ?? "image":
          await MultipartFile.fromFile(filePath, filename: fName),
    };
    data = FormData.fromMap(body);
    log('dio', 'files $body');
  } else if (filePathList != null) {
    for (String path in filePathList) {
      String fileName = path.split('/').last;
      data = FormData.fromMap({
        filePathListName ?? "images[]":
            await MultipartFile.fromFile(path, filename: fileName),
      });
    }
  } else if (filesPath != null) {
    Map<String, dynamic> body = {};
    for (FileModel file in filesPath) {
      if (file.path != null) {
        log('dio', 'file - name: ${file.name} - path: ${file.path}  ');
        String fileName = file.path!.split('/').last;
        body.addAll({
          file.name:
              await MultipartFile.fromFile(file.path!, filename: fileName)
        });
      } else {
        for (var i = 0; i <= (file.paths?.length ?? 0) - 1; i++) {
          String path = file.paths![i];
          // for(String path in file.paths??[]){
          log('dio', 'files name: ${file.name}[$i] - path: $path  ');
          String fileName = path.split('/').last;
          body.addAll({
            '${file.name}[$i]':
                await MultipartFile.fromFile(path, filename: fileName)
          });
        }
      }
    }
    log('dio', 'files $body');
    data = FormData.fromMap(body);
  }
  return data;
}

class FileModel {
  final String name;
  final String? path;
  final List<String>? paths;

  const FileModel({
    required this.name,
    this.path,
    this.paths,
  });
}
