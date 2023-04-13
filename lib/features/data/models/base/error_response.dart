import '../../../../core/utils/logger.dart';

/// errors : [{"code":"l_name","message":"The last name field is required."},{"code":"password","message":"The password field is required."}]
/// errors : [{"message":"The last name field is required."},{"code":"password","message":"The password field is required."}]
/// errors : [{"phone":"رقم التليفون غير موجود"},{"email":"البريد الالكتروني موجود بالفعل"}]

class ErrorResponse {
  List<Errors>? _errors;
  List<Errors>? get errors => _errors;

  String? _message;
  String? get message => _message;

  ErrorResponse({List<Errors>? errors}) {
    _errors = errors;
  }

  ErrorResponse.fromJson(dynamic json) {
    _errors = [];
    if (json["errors"] != null) {
      if (json["errors"] is String) {
        _message = json["errors"];
      } else {
        Map<String, dynamic> error = json["errors"];

        for (String key in error.keys) {
          String errorString = error[key][0];

          if (_message == null) {
            _message = errorString;
          } else {
            _message = '$_message \n $errorString';
          }

          _errors!.add(Errors(key, errorString));
          log('Errors', 'Error ${_errors.toString()}');
        }
      }
    } else if (json["message"] != null) {
      _errors!.add(Errors('error', json["message"]));
      _message = json["message"];
      log('Errors', 'Error ${json["message"]}');
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_errors != null) {
      map["errors"] = _errors!.map((v) => v).toList();
    }
    return map;
  }
}

/// code : "l_name"
/// message : "The last name field is required."

class Errors {
  final String? _key;
  final String? _value;

  String? get key => _key;

  String? get value => _value;

  Errors(this._key, this._value);

  @override
  String toString() {
    return 'Errors{_key: $_key, _value: $_value}';
  }
}

/*

import 'package:alashraf/domain/logger.dart';

class ErrorResponse {
  String? type;
  String? title;
  int? status;
  String? detail;
  String? path;
  String? message;

  ErrorResponse(
      {this.type,
        this.title,
        this.status,
        this.detail,
        this.path,
        this.message});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    log('ErrorResponse', '${json['message']}');

    type = json['type'];
    title = json['title'];
    status = json['status'];
    detail = json['detail'];
    path = json['path'];
    message = json['message']??'Error';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['status'] = status;
    data['detail'] = detail;
    data['path'] = path;
    data['message'] = message;
    return data;
  }
}
*/
