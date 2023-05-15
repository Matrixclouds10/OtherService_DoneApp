enum CheckOTPType { register, reset }

class CheckOTPBody {
  final String _phone;
  final String _code;
  final String _otp;
  final CheckOTPType _type;
  final bool typeIsProvider;

  const CheckOTPBody({
    required this.typeIsProvider,
    required String phone,
    required String code,
    required String otp,
    required CheckOTPType type,
  })  : _phone = phone,
        _code = code,
        _otp = otp,
        _type = type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_number'] = _phone;
    data['country_code'] = _code;
    data['otp'] = _otp;
    data['type'] = _type.name;
    return data;
  }
}
