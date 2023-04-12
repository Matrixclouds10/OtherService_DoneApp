import 'package:weltweit/data/datasource/remote/exception/api_checker.dart';
import 'package:weltweit/data/model/base/api_response.dart';
import 'package:weltweit/data/model/base/base_model.dart';
import 'package:weltweit/data/model/base/response_model.dart';
import 'package:weltweit/domain/logger.dart';
import 'package:flutter/foundation.dart';


class BaseUseCaseCall<R> {
  static ResponseModel<R> onGetData<R>(ApiResponse apiResponse,
      ResponseModel<R> Function(BaseModel baseModel) onConvert,
      {bool showError = true, String? tag}) {
    ResponseModel<R> responseModel;

    _log(tag, apiResponse.response);
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201)) {
      BaseModel baseModel = BaseModel.fromJson(apiResponse.response!.data);
      if (baseModel.status) {
        _log(tag, 'getData successfully');
        if (kDebugMode) {
          _log(tag, 'getData kDebugMode');
          responseModel = onConvert(baseModel);
        } else {
          try {
            responseModel = onConvert(baseModel);
          } catch (e) {
            _log(tag, 'getData onConvert Error');
            responseModel = ApiChecker.checkApi<R>(message: baseModel.message);
          }
        }
      } else {
        responseModel = ApiChecker.checkApi<R>(
            showError: showError,
            apiResponse: ApiResponse.withError(baseModel.message));
      }
    } else {
      _log(tag,
          'getData onConvert API Error - ${apiResponse.error ?? apiResponse.response?.data['message']}');
      responseModel = ApiChecker.checkApi<R>(
          showError: showError,
          apiResponse: ApiResponse.withError(apiResponse.error));
    }
    return responseModel;
  }
}

_log(String? tag, var massage) {
  if (tag != null) {
    log(tag, 'response :$massage ');
  }
}

/*

class BaseUseCaseCall<R>{
  static ResponseModel<R> onGetData<R>(ApiResponse apiResponse, ResponseModel<R> Function(BaseModel baseModel) onConvert,{bool showError = true,String? tag}){
    ResponseModel<R> responseModel;

    _log(tag,apiResponse.response );
    if (apiResponse.response != null &&( apiResponse.response!.statusCode == 200 || apiResponse.response!.statusCode == 201) ) {
      BaseModel baseModel = BaseModel.fromJson(apiResponse.response!.data);
      if (baseModel.status) {
        _log(tag,'getData successfully');
        if (kDebugMode) {
          _log(tag,'getData kDebugMode');
          responseModel = onConvert(baseModel);
        } else{
          try {
            responseModel = onConvert(baseModel);
          } catch (e) {
            _log(tag,'getData onConvert Error');
            responseModel = ApiChecker.checkApi<R>( message: baseModel.message);
          }
        }
      } else {

        switch(baseModel.code) {
          case '700': responseModel = ApiChecker.checkApi<R>(showError: showError, message: tr(LocaleKeys.accountNotActive));break;
          case '701': responseModel = ApiChecker.checkApi<R>(showError: showError, message: tr(LocaleKeys.theEmailNumberAlreadyExists));break;
          case '702': responseModel = ApiChecker.checkApi<R>(showError: showError, message: tr(LocaleKeys.accountNotActive));break;
          case '703': responseModel = ApiChecker.checkApi<R>(showError: showError, message: tr(LocaleKeys.accountNotActive));break;
          case '704': responseModel = ApiChecker.checkApi<R>(showError: showError, message: tr(LocaleKeys.passwordIsWrong));break;
          default:  responseModel = ApiChecker.checkApi<R>(showError: showError, message: apiResponse.response?.data);
        }

        _log(tag, 'getData onConvert API Body Error - ${baseModel.message}');
      }
    } else {
      _log(tag,'getData onConvert API Error - ${apiResponse.error??apiResponse.response?.data['message']}');
      responseModel = ApiChecker.checkApi<R>(showError: showError,apiResponse: ApiResponse.withError(apiResponse.error??apiResponse.response?.data['message']));
    }
    return responseModel;
  }


}
_log(String? tag,var massage){
  if (tag!=null) {
    log(tag, 'response :$massage ');
  }
}*/
