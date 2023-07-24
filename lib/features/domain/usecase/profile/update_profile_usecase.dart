import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class UpdateProfileUseCase implements BaseUseCase<UserModel, UpdateProfileParams> {
  final AppRepository repository;

  UpdateProfileUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, UserModel>> call(UpdateProfileParams params) {
    return repository.updateProfile(params: params);
  }

  @override
  Future<Either<ErrorModel, UserModel>> callTest(UpdateProfileParams params) {
    throw UnimplementedError();
  }
}

class UpdateProfileParams {
  String? name;
  int? countryId;
  int? cityId;
  int? regionId;
  String? email;
  File? image;
  String? mobileNumber;
  String? countryCode;
  String? countryIso;
  bool genderIsMale;

  UpdateProfileParams({
    this.name,
    this.email,
    this.cityId,
    this.regionId,
    this.image,
    this.mobileNumber,
    this.countryCode,
    required this.countryId,
    this.countryIso,
    this.genderIsMale = true,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (countryId != null) data['country_id'] = countryId;
    if (cityId != null) data['city_id'] = cityId;
    if (regionId != null) data['region_id'] = regionId;
    if (email != null) data['email'] = email;
    if (mobileNumber != null) data['mobile'] = mobileNumber;
    if (countryCode != null) data['country_code'] = countryCode;
    if (countryIso != null) data['country_iso'] = countryIso;
    data['gender'] = genderIsMale ? 'male' : 'female';
    return data;
  }
}
