import 'dart:io';

import 'package:weltweit/features/data/models/response/country/country_model.dart';

class RegisterBody {
  final String name;
  final String mobile;
  final String email;
  final String password;
  final String confirmPassword;
  final CountryModel country;
  final bool isConfirmTerms;
  final File? image;
  final bool? isIndividual;
  final bool typeIsProvider;

  RegisterBody({
    this.image,
    this.name = '',
    this.mobile = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isConfirmTerms = false,
    this.isIndividual = true,
    required this.country,
    required this.typeIsProvider,
  });

  copyWith({
    String? name,
    String? mobile,
    String? email,
    String? password,
    String? confirmPassword,
    CountryModel? country,
    bool? isConfirmTerms,
    bool? isIndividual,
    bool? typeIsProvider,
    File? image,
  }) {
    return RegisterBody(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      country: country ?? this.country,
      isConfirmTerms: isConfirmTerms ?? this.isConfirmTerms,
      isIndividual: isIndividual ?? this.isIndividual,
      image: image ?? this.image,
      typeIsProvider: typeIsProvider ?? this.typeIsProvider,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile_number'] = mobile;
    data['email'] = email;
    data['password'] = password;
    data['country_code'] = country.code ?? '20';
    data['country_iso'] = country.code ?? 'EG';
    data['country_id'] = country.id ;
    if (isIndividual != null) data['is_company'] = isIndividual! ? 0 : 1;

    return data;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   (_name ?? '').isNotEmpty ? data['name'] = _name : null;
  //   (_mobile ?? '').isNotEmpty ? data['mobile_number'] = _mobile : null;
  //   (_email ?? '').isNotEmpty ? data['email'] = _email : null;

  //   data['password'] = _password;
  //   data['country_code'] = _country.dialCode;
  //   data['country_iso'] = _country.code;

  //   return data;
  // }
}