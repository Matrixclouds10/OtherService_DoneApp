import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';

import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';
class UpdateProfileProviderUseCase
    implements BaseUseCase<UserModel, UpdateProfileParams> {
  final AppRepositoryProvider repository;

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
  bool genderIsMale;

  UpdateProfileParams({
    this.name,
    this.email,
    this.image,
    this.mobileNumber,
    this.countryCode,
    this.countryIso,
    this.genderIsMale = true,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (mobileNumber != null) data['mobile'] = mobileNumber;
    if (countryCode != null) data['country_code'] = countryCode;
    if (countryIso != null) data['country_iso'] = countryIso;
    if (genderIsMale != null) data['gender'] = genderIsMale ? 'male' : 'female';
    return data;
  }
}
