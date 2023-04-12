class ErrorModel {
  final ErrorEnum? codeError;
  final int? code;
  final String? errorMessage;
  final String? image;

  const ErrorModel({
    this.codeError,
    this.code,
    required this.errorMessage,
    this.image,
  });
}

enum ErrorEnum {
  /// It occurs when url is opened timeout.
  connectTimeout,

  /// It occurs when url is sent timeout.
  sendTimeout,

  ///It occurs when receiving timeout.
  receiveTimeout,

  /// When the server response, but with a incorrect status, such as 404, 503...
  response,

  /// When the request is cancelled, dio will throw a error with this type.
  cancel,

  /// Default error type, Some other Error. In this case, you can
  /// use the DioError.error if it is not null.
  other,

  auth,
  server,

  otherError
}
