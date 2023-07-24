import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/services/network/network_client.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/app_urls/client_endpoints_url.dart';
import 'package:weltweit/features/data/models/banner/banner_model.dart';
import 'package:weltweit/features/data/models/chat/chat_model.dart';
import 'package:weltweit/features/data/models/location/city_model.dart';
import 'package:weltweit/features/data/models/location/region_model.dart';
import 'package:weltweit/features/data/models/notification/notification_model.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/data/models/portfolio/portfolio_image.dart';
import 'package:weltweit/features/data/models/provider/provider_rates_model.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/features/data/models/services/services_response.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/domain/usecase/banner/banner_usecase.dart';
import 'package:weltweit/features/domain/usecase/chat_messages/chat_messages_usecase.dart';
import 'package:weltweit/features/domain/usecase/chat_send_message/chat_send_message_usecase.dart';
import 'package:weltweit/features/domain/usecase/contact_us/contact_us_usecase.dart';
import 'package:weltweit/features/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/domain/usecase/location/cities_usecase.dart';
import 'package:weltweit/features/domain/usecase/location/regions_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_accept_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_cancel_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_finish_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_rate_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/orders_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/domain/usecase/services/update_services_usecase.dart';

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
    AppPrefs prefs = getIt.get<AppPrefs>();
    bool isProvider = prefs.get(PrefKeys.isTypeProvider, defaultValue: false);
    String url = isProvider ? AppURL.deleteProfileProvider : AppURL.deleteProfile;
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
    AppPrefs prefs = getIt.get<AppPrefs>();
    int? countryId = prefs.get(PrefKeys.countryId);

    Map<String, dynamic> data = {
      "page": page,
      "country_id": countryId,
    };
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

    AppPrefs prefs = getIt.get<AppPrefs>();
    int? countryId = prefs.get(PrefKeys.countryId);
    Map<String, dynamic> data = {"country_id": countryId};

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

    List<File>? files = params.files;
    FormData? formData;
    if (files != null && files.isNotEmpty) {
      formData = FormData.fromMap({
        for (int i = 0; i < files.length; i++) 'file[$i]': await MultipartFile.fromFile(files[i].path, filename: files[i].path.split('/').last),
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
    AppPrefs prefs = getIt.get<AppPrefs>();
    bool isProvider = prefs.get(PrefKeys.isTypeProvider, defaultValue: false);
    String url = isProvider ? "${AppURL.providerGetOrder}/$params" : "${AppURL.getOrder}/$params";
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
    AppPrefs prefs = getIt.get<AppPrefs>();
    bool isProvider = prefs.get(PrefKeys.isTypeProvider, defaultValue: false);

    String url = isProvider ? AppURL.providerCancelOrder : AppURL.cancelOrder;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> acceptOrder({required OrderAcceptParams params}) async {
    String url = AppURL.providerAcceptOrder;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> finishOrder({required OrderFinishParams params}) async {
    AppPrefs prefs = getIt.get<AppPrefs>();
    bool isProvider = prefs.get(PrefKeys.isTypeProvider, defaultValue: false);

    String url = isProvider ? AppURL.providerOrderFinish : AppURL.orderDone;
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
  Future<Either<ErrorModel, List<CityModel>>> getCities({required CitiesParams params}) async {
    String url = AppURL.cities;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<CityModel> data = r.data.map<CityModel>((e) => CityModel.fromJson(e)).toList();
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, List<RegionModel>>> getRegions({required RegionsParams params}) async {
    String url = AppURL.regions;
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = params.toJson();
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<RegionModel> data = r.data.map<RegionModel>((e) => RegionModel.fromJson(e)).toList();
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
    AppPrefs prefs = getIt<AppPrefs>();
    kEcho("getbanner init");
    int? countryId = prefs.get(PrefKeys.countryId, defaultValue: null);

    Map<String, dynamic> data = {
      if (countryId != null) 'country_id': countryId,
    };
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

    AppPrefs prefs = getIt.get<AppPrefs>();
    int? countryId = prefs.get(PrefKeys.countryId);
    Map<String, dynamic> data = {"country_id": countryId};

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
  Future<Either<ErrorModel, BaseResponse>> orderRate({required OrderRateParams params}) {
    String url = AppURL.orderRate;
    NetworkCallType type = NetworkCallType.post;
    Map<String, dynamic> data = params.toJson();
    return networkClient(url: url, data: data, type: type).then((value) {
      return value.fold((l) => Left(l), (r) => Right(r));
    });
  }

  @override
  Future<Either<ErrorModel, List<ProviderRateModel>>> getProviderRates({required int id}) async {
    String url = "${AppURL.getProviderRates}/$id";
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<ProviderRateModel> data = r.data.map<ProviderRateModel>((e) => ProviderRateModel.fromJson(e)).toList();
        return Right(data);
      } catch (e) {
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }

  @override
  Future<Either<ErrorModel, BaseResponse<List<NotificationModel>>>> getNotifications(int parameters) async {
    String url = AppURL.getNotifications;
    if (parameters != 0) {
      url = '$url?page=$parameters';
    }
    NetworkCallType type = NetworkCallType.get;
    Map<String, dynamic> data = {};
    Either<ErrorModel, BaseResponse> result = await networkClient(url: url, data: data, type: type);
    return result.fold((l) => Left(l), (r) {
      try {
        List<NotificationModel> data = r.data["data"].map<NotificationModel>((e) => NotificationModel.fromJson(e)).toList();
        BaseResponse<List<NotificationModel>> baseResponse = BaseResponse<List<NotificationModel>>(data: data, meta: r.meta);
        print("------> data ${data.length}");
        return Right(baseResponse);
      } catch (e) {
        print("------> e ${e.toString()}");
        return Left(ErrorModel(errorMessage: e.toString()));
      }
    });
  }
}
