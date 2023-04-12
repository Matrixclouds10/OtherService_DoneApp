import '../../datasource/remote/exception/error_widget.dart';

class ResponseModel<T> {
  final bool _isSuccess;
  final String? _message;
  final ErrorModel? _error;
  T? data;

  ResponseModel(
    this._isSuccess,
    this._message, {
    this.data,
    ErrorModel? error,
  }) : _error = error;

  String? get message => _message;

  ErrorModel? get error => _error;

  bool get isSuccess => _isSuccess;
// dynamic get data => data;
}
