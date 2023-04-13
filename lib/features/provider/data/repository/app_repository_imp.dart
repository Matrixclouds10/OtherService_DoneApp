import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/core/services/network/network_client.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/provider/data/app_urls/app_url.dart';
import 'package:weltweit/features/provider/data/models/response/documents/document.dart';
import 'package:weltweit/features/provider/data/models/response/portfolio/portfolio_image.dart';
import 'package:weltweit/features/provider/data/models/response/services/service.dart';
import 'package:weltweit/features/provider/domain/repository/app_repo.dart';
import 'package:weltweit/features/provider/domain/usecase/document/document_add_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/portfolio/portfolio_update_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/services/update_services_usecase.dart';

class AppRepositoryImp implements AppRepository {
  final NetworkClient networkClient;
  AppRepositoryImp({required this.networkClient});

  @override
  Future<Either<ErrorModel, UserModel>> getProfile() async {
    String url = AppURL.profile;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        UserModel userModel = UserModel.fromJson(r.data);
        return Right(userModel);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, UserModel>> updateAvailability() async {
    String url = AppURL.changeStatus;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        UserModel userModel = UserModel.fromJson(r.data);
        return Right(userModel);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, UserModel>> updateProfile({required UpdateProfileParams params}) async {
    String url = AppURL.updateProfile;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();

    File? file = params.image;
    FormData? formData;
    if (file != null) {
      formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });
    }
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, formData: formData, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        UserModel userModel = UserModel.fromJson(r.data);
        return Right(userModel);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, bool>> deleteProfile({required int id}) async {
    String url = "${AppURL.deleteProfile}/$id";
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        return Right(true);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> addDocument({required DocumentParams params}) async {
    String url = AppURL.addDocumentURI;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    FormData formData = await params.toFormData();

    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, formData: formData, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> deleteDocument({required int id}) async {
    String url = '${AppURL.deleteDocumentURI}/$id';
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, List<Document>>> getDocuments() async {
    String url = AppURL.getDocumentsURI;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<Document> documents = r.data.map<Document>((e) => Document.fromJson(e)).toList();
        return Right(documents);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> updateDocument({required DocumentParams params}) async {
    String url = '${AppURL.updateDocumentURI}/$id';
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, formData: await params.toFormData(), data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> changePassword({required ChangePasswordParams params}) async {
    String url = AppURL.changePasswordProfile;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> getAllServices() async {
    String url = AppURL.services;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<ServiceModel> services = r.data.map<ServiceModel>((e) => ServiceModel.fromJson(e)).toList();
        return Right(services);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> getMyServices() async {
    String url = AppURL.myServices;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<ServiceModel> services = r.data.map<ServiceModel>((e) => ServiceModel.fromJson(e)).toList();
        return Right(services);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> updateFcm({required String fcmToken}) async {
    String url = AppURL.updateFcm;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> updateLocation({required String lat, required String lng}) async {
    String url = AppURL.updateLocation;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {"lat": lat, "lng": lng};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> updateMyServices({required UpdateServicesParams params}) async {
    String url = AppURL.updateMyServices;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<ServiceModel> services = r.data.map<ServiceModel>((e) => ServiceModel.fromJson(e)).toList();
        return Right(services);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> addPortfolio({required File image}) async {
    String url = AppURL.addPortfolioURI;
    NetworkCallType type = NetworkCallType.post;
    FormData formData = FormData.fromMap({"image": await MultipartFile.fromFile(image.path)});

    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, formData: formData, data: {}, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> deletePortfolio({required int id}) async {
    String url = '${AppURL.deletePortfolioURI}/$id';
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, List<PortfolioModel>>> getPortfolios() async {
    String url = AppURL.getPortfoliosURI;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        if (r.data['data'] != null) {
          //TODO this will be removed after the backend fix
          List<PortfolioModel> documents = r.data['data'].map<PortfolioModel>((e) => PortfolioModel.fromJson(e)).toList();
          return Right(documents);
        }
        List<PortfolioModel> documents = r.data.map<PortfolioModel>((e) => PortfolioModel.fromJson(e)).toList();
        return Right(documents);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> updatePortfolio({required PortfolioParams params}) async {
    String url = AppURL.updatePortfolioURI;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {"id": params.id};
    FormData formData = FormData.fromMap({"image": await MultipartFile.fromFile(params.image.path)});
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, formData: formData, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
