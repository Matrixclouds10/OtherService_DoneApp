import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/services/network/network_client.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/data/models/response/country/country_model.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/services/data/app_urls/app_url.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/services/data/models/response/banner/banner_model.dart';
import 'package:weltweit/features/services/data/models/response/chat/chat_model.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/features/services/data/models/response/portfolio/portfolio_image.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import 'package:weltweit/features/services/data/models/response/services/services_response.dart';
import 'package:weltweit/features/domain/usecase/chat_messages/chat_messages_usecase.dart';
import 'package:weltweit/features/domain/usecase/contact_us/contact_us_usecase.dart';
import 'package:weltweit/features/domain/usecase/chat_send_message/chat_send_message_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/banner/banner_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/order_cancel/order_cancel_usecase.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';
import 'package:weltweit/features/services/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/orders/orders_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/services/update_services_usecase.dart';

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
    logger.d("file:formData $file");
    FormData? formData;
    if (file != null) {
      formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });
    }
    Either<ErrorModel, BaseResponse> result = await networkClient(
      url: url,
      formData: formData,
      data: data,
      type: type,
    );
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
  Future<Either<ErrorModel, BaseResponse>> changePassword({required ChangePasswordParams params}) async {
    String url = AppURL.changePasswordProfile;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, ServicesResponse>> getAllServices({required int page}) async {
    String url = AppURL.services;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {"page": page};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) {
      try {
        List<ServiceModel> services = r.data['data'].map<ServiceModel>((e) => ServiceModel.fromJson(e)).toList();
        int? totalPage = r.meta?.pagination.totalPages;
        return Right(ServicesResponse(
          totalPages: totalPage ?? 1,
          service: services,
        ));
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
    String url = AppURL.updateFcm;
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
  Future<Either<ErrorModel, List<ProvidersModel>>> getProviders({required ProvidersParams params}) async {
    String url = AppURL.getProviders;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {};
    data.addAll(params.toJson());
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) {
      try {
        List<ProvidersModel> providers = r.data.map<ProvidersModel>((e) => ProvidersModel.fromJson(e)).toList();
        return Right(providers);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> addToFavorites({required int id}) async {
    String url = AppURL.addFavorite;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = {"provider_id": id};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> getFavorites() async {
    String url = AppURL.getFavorites;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) {
      try {
        List<ProvidersModel> providers = r.data.map<ProvidersModel>((e) => ProvidersModel.fromJson(e)).toList();
        return Right(providers);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, ProvidersModel>> getProvider({required int id}) async {
    String url = "${AppURL.getProvider}/$id";
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) {
      try {
        ProvidersModel provider = ProvidersModel.fromJson(r.data);
        return Right(provider);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<PortfolioModel>>> getProviderPortfolio({required int id}) async {
    String url = "${AppURL.getProviderPortfolio}/$id";
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) {
      try {
        List<PortfolioModel> portfolio = r.data['data'].map<PortfolioModel>((e) => PortfolioModel.fromJson(e)).toList();
        return Right(portfolio);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<ServiceModel>>> getProviderServices({required int id}) async {
    String url = "${AppURL.getProviderServices}/$id";
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
  Future<Either<ErrorModel, OrderModel>> createOrder({required CreateOrderParams params}) async {
    String url = AppURL.createOrder;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();

    File? file = params.file;
    FormData? formData;
    if (file != null) {
      formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });
    }

    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type, formData: formData);
    return result.fold((l) => Left(l), (r) {
      try {
        OrderModel data = OrderModel.fromJson(r.data);
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, OrderModel>> getOrder({required int params}) async {
    String url = "${AppURL.getOrder}/$params";
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        OrderModel data = OrderModel.fromJson(r.data);
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<OrderModel>>> getOrders({required OrdersParams params}) async {
    String url = params.typeIsProvider ? AppURL.providerGetPendingOrders : AppURL.getPendingOrders;
    if (params.ordersStatus == OrdersStatus.cancelled) url = params.typeIsProvider ? AppURL.providerGetCancelledOrders : AppURL.getCancelledOrders;
    if (params.ordersStatus == OrdersStatus.completed) url = params.typeIsProvider ? AppURL.providerGetCompletedOrders : AppURL.getCompletedOrders;

    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<OrderModel> data = r.data.map<OrderModel>((e) => OrderModel.fromJson(e)).toList();
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> cancelOrder({required OrderCancelParams params}) async {
    String url = AppURL.cancelOrder;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, String>> getAbout() async {
    String url = AppURL.about;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        String data = '${r.data['about_us']}';
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<ChatModel>>> getChatMessages({required ChatMessagesParams params}) async {
    AppPrefs prefs = getIt<AppPrefs>();
    bool isProvider = prefs.get(PrefKeys.isTypeProvider);
    String url = isProvider ? AppURL.getChatMessagesProvider : AppURL.getChatMessagesClient;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) => Right(r.data.map<ChatModel>((e) => ChatModel.fromJson(e)).toList()));
  }

  @override
  Future<Either<ErrorModel, String>> getPolicy() async {
    String url = AppURL.privacy;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) {
      try {
        String data = '${r.data['privacy']}';
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> sendChatMessage({required ChatSendMessageParams params}) async {
    AppPrefs prefs = getIt<AppPrefs>();
    bool isProvider = prefs.get(PrefKeys.isTypeProvider);
    String url = isProvider ? AppURL.sendMessageProvider : AppURL.sendMessageClient;
    NetworkCallType type = NetworkCallType.post;

    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(
      url: url,
      data: data,
      type: type,
      formData: await params.toJsonFormData(),
    );

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> sendContactUs({required ContactUsParams params}) async {
    String url = AppURL.contactUs;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, List<CountryModel>>> getCountries({required NoParameters params}) async {
    String url = AppURL.countries;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<CountryModel> data = r.data.map<CountryModel>((e) => CountryModel.fromJson(e)).toList();
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, CountryModel>> getcountry({required int id}) async {
    String url = '${AppURL.country}/$id';
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        CountryModel data = CountryModel.fromJson(r.data);
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<BannerModel>>> getbanner({required BannerParams params}) async {
    String url = AppURL.banners;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<BannerModel> data = r.data.map<BannerModel>((e) => BannerModel.fromJson(e)).toList();
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> getMostRequestedProviders() async {
    String url = AppURL.getMostRequestedProviders;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) {
      try {
        List<ProvidersModel> providers = r.data.map<ProvidersModel>((e) => ProvidersModel.fromJson(e)).toList();
        return Right(providers);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }
}
