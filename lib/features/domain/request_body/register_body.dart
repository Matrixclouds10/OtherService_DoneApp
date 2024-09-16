import 'dart:io';

import 'package:weltweit/features/data/models/location/city_model.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/data/models/location/region_model.dart';

class RegisterBody {
  final String name;
  final String mobile;
  final String? whatsappNumber;
  final String? promoCode;
  final String email;
  final String password;
  final String confirmPassword;
  final CountryModel country;
  final CityModel? cityModel;
  final RegionModel? regionModel;
  final bool isConfirmTerms;
  final File? image;
  final bool? isIndividual;
  final bool typeIsProvider;

  RegisterBody({
    this.image,
    this.name = '',
    this.mobile = '',
    this.whatsappNumber,
    this.email = '',
    this.promoCode = '',
    this.password = '',
    this.confirmPassword = '',
    this.isConfirmTerms = false,
    this.isIndividual = true,
    required this.country,
    required this.cityModel,
    required this.regionModel,
    required this.typeIsProvider,
  });

  copyWith({
    String? name,
    String? mobile,
    String? whatsappNumber,
    String? email,
    String? promoCode,
    String? password,
    String? confirmPassword,
    CountryModel? country,
    CityModel? cityModel,
    RegionModel? regionModel,
    bool? isConfirmTerms,
    bool? isIndividual,
    bool? typeIsProvider,
    File? image,
  }) {
    return RegisterBody(
      name: name ?? this.name,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      promoCode: promoCode ?? this.promoCode,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      country: country ?? this.country,
      cityModel: cityModel ?? this.cityModel,
      regionModel: regionModel ?? this.regionModel,
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
    data['promo_code'] = promoCode;
    data['password'] = password;
    data['country_code'] = country.code ?? '20';
    data['country_iso'] = country.code ?? 'EG';
    data['country_id'] = country.id;
    if (whatsappNumber != null) data['whatsapp_number'] = whatsappNumber;
    if (cityModel != null) data['city_id'] = cityModel!.id;
    if (regionModel != null) data['region_id'] = regionModel!.id;
    if (isIndividual != null) data['is_company'] = isIndividual! ? 0 : 1;

    return data;
  }
}
