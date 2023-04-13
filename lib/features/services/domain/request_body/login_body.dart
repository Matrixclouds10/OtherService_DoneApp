class LoginBody {
  String _phone;
  String _code;
  String _password;
  String _deviceToken;

  LoginBody({
    required String phone,
    String code = '966',
    required String password,
    required String deviceToken,
  })  : _phone = phone,
        _code = code,
        _password = password,
        _deviceToken = deviceToken;

  String get deviceToken => _deviceToken;
  String get password => _password;
  String get code => _code;
  String get phone => _phone;

  Map<String, dynamic> toJson() {
    return {
      "mobile_number": _phone,
      "password": _password,
      "country_code": _code,
      "fcm_token": _deviceToken,
    };
  }

  setData({
    required String phone,
    required String password,
    required String deviceToken,
  }) {
    _phone = phone;
    _password = password;
    _deviceToken = deviceToken;
  }

  updateCode(String? code) {
    _code = code ?? '966';
  }
}
