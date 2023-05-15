import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';

import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';
class UpdateProfileProviderUseCase
    implements BaseUseCase<UserModel, UpdateProfileParams> {
  final ProviderRepositoryProvider repository;

  UpdateProfileProviderUseCase({required this.repository});

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
  String? email;
  File? image;
  String? mobileNumber;
  String? countryCode;
  String? countryIso;
  String? description;
  int? countryId;
  bool genderIsMale;

  UpdateProfileParams({
    this.name,
    this.email,
    this.image,
    this.mobileNumber,
    this.countryCode,
    this.countryIso,
    required this.description,
    required this.countryId,
    this.genderIsMale = true,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countryId != null) data['country_id'] = countryId;
    if (description != null) data['description'] = description;
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (mobileNumber != null) data['mobile'] = mobileNumber;
    if (countryCode != null) data['country_code'] = countryCode;
    if (countryIso != null) data['country_iso'] = countryIso;
 data['gender'] = genderIsMale ? 'male' : 'female';
    return data;
  }
}
