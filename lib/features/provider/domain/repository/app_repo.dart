import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/provider/data/models/response/documents/document.dart';
import 'package:weltweit/features/provider/data/models/response/portfolio/portfolio_image.dart';
import 'package:weltweit/features/provider/data/models/response/services/service.dart';
import 'package:weltweit/features/provider/domain/usecase/document/document_add_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_update_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/update_services_usecase.dart';

abstract class AppRepositoryProvider {
  Future<Either<ErrorModel, UserModel>> getProfile();
  Future<Either<ErrorModel, bool>> deleteProfile({required int id});
  Future<Either<ErrorModel, UserModel>> updateAvailability();
  Future<Either<ErrorModel, UserModel>> updateProfile({required UpdateProfileParams params});
  Future<Either<ErrorModel, BaseResponse>> changePassword({required ChangePasswordParams params});

  //* Settings
  Future<Either<ErrorModel, BaseResponse>> updateFcm({required String fcmToken});
  Future<Either<ErrorModel, BaseResponse>> updateLocation({required String lat, required String lng});

  //* Services
  Future<Either<ErrorModel, List<ServiceModel>>> getAllServices();
  Future<Either<ErrorModel, List<ServiceModel>>> getMyServices();
  Future<Either<ErrorModel, List<ServiceModel>>> updateMyServices({required UpdateServicesParams params});

  //* Documents
  Future<Either<ErrorModel, List<Document>>> getDocuments();
  Future<Either<ErrorModel, BaseResponse>> addDocument({required DocumentParams params});
  Future<Either<ErrorModel, BaseResponse>> updateDocument({required DocumentParams params});
  Future<Either<ErrorModel, BaseResponse>> deleteDocument({required int id});

  //* Portfolio
  Future<Either<ErrorModel, List<PortfolioModel>>> getPortfolios();
  Future<Either<ErrorModel, BaseResponse>>   addPortfolio({required File image});
  Future<Either<ErrorModel, BaseResponse>>   updatePortfolio({required PortfolioParams params});
  Future<Either<ErrorModel, BaseResponse>>   deletePortfolio({required int id});
}
