import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/location/city_model.dart';
import 'package:weltweit/features/data/models/location/region_model.dart';
import 'package:weltweit/features/data/models/notification/notification_model.dart';
import 'package:weltweit/features/data/models/provider/provider_rates_model.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/domain/usecase/location/cities_usecase.dart';
import 'package:weltweit/features/domain/usecase/location/regions_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_accept_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_cancel_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_finish_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/order_rate_usecase.dart';
import 'package:weltweit/features/domain/usecase/order/orders_usecase.dart';
import 'package:weltweit/features/data/models/banner/banner_model.dart';
import 'package:weltweit/features/data/models/chat/chat_model.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/data/models/portfolio/portfolio_image.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/features/data/models/services/services_response.dart';
import 'package:weltweit/features/domain/usecase/chat_messages/chat_messages_usecase.dart';
import 'package:weltweit/features/domain/usecase/chat_send_message/chat_send_message_usecase.dart';
import 'package:weltweit/features/domain/usecase/contact_us/contact_us_usecase.dart';
import 'package:weltweit/features/domain/usecase/banner/banner_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/domain/usecase/services/update_services_usecase.dart';

import '../../data/models/order/invoice.dart';
import '../../data/models/wallet/wallet_model.dart';
import '../usecase/order/start_go_to_client_usecase.dart';

abstract class AppRepository {
  //* Auth
  Future<Either<ErrorModel, UserModel>> getProfile();
  Future<Either<ErrorModel, bool>> updateUserLocation(LatLng latLng);
  Future<Either<ErrorModel, bool>> deleteProfile({required int id});
  Future<Either<ErrorModel, UserModel>> updateProfile({required UpdateProfileParams params});
  Future<Either<ErrorModel, BaseResponse>> changePassword({required ChangePasswordParams params});

  //Wallet
  Future<Either<ErrorModel, List<WalletModel>>> getWalletUser();
  Future<Either<ErrorModel, BaseResponse>> convertPoints();

  //* Settings
  Future<Either<ErrorModel, BaseResponse>> updateFcm({required String fcmToken});

  //* Services
  Future<Either<ErrorModel, ServicesResponse>> getAllServices({required int page});
  Future<Either<ErrorModel, List<ServiceModel>>> updateMyServices({required UpdateServicesParams params});

  //* Providers
  Future<Either<ErrorModel, List<ProvidersModel>>> getProviders({required ProvidersParams params});
  Future<Either<ErrorModel, List<ProvidersModel>>> getMostRequestedProviders();
  Future<Either<ErrorModel, ProvidersModel>> getProvider({required int id});
  Future<Either<ErrorModel, List<ServiceModel>>> getProviderServices({required int id});
  Future<Either<ErrorModel, List<PortfolioModel>>> getProviderPortfolio({required int id});

  //*Favorites
  Future<Either<ErrorModel, BaseResponse>> addToFavorites({required int id});
  Future<Either<ErrorModel, List<ProvidersModel>>> getFavorites();

  Future<Either<ErrorModel, List<OrderModel>>> getOrders({required OrdersParams params});
  Future<Either<ErrorModel, InvoiceModel>> getInvoiceOrder({required int id});
  Future<Either<ErrorModel, OrderModel>> getOrder({required int params});
  Future<Either<ErrorModel, OrderModel>> createOrder({required CreateOrderParams params});
  Future<Either<ErrorModel, BaseResponse>> cancelOrder({required OrderCancelParams params});
  Future<Either<ErrorModel, BaseResponse>> acceptOrder({required OrderAcceptParams params});
  Future<Either<ErrorModel, BaseResponse>> finishOrder({required OrderFinishParams params});
  Future<Either<ErrorModel, BaseResponse>> startGoToClient({required StartGoToClientParams params});

  Future<Either<ErrorModel, String>> getAbout();
  Future<Either<ErrorModel, String>> getPolicy();
  Future<Either<ErrorModel, BaseResponse>> sendContactUs({required ContactUsParams params});
  Future<Either<ErrorModel, BaseResponse>> sendChatMessage({required ChatSendMessageParams params});
  Future<Either<ErrorModel, List<ChatModel>>> getChatMessages({required ChatMessagesParams params});

  Future<Either<ErrorModel, CountryModel>> getcountry({required int id});
  Future<Either<ErrorModel, List<CountryModel>>> getCountries({required NoParameters params});
  Future<Either<ErrorModel, List<CityModel>>> getCities({required CitiesParams params});
  Future<Either<ErrorModel, List<RegionModel>>> getRegions({required RegionsParams params});

  Future<Either<ErrorModel, List<BannerModel>>> getbanner({required BannerParams params});

  Future<Either<ErrorModel, BaseResponse>> orderRate({required OrderRateParams params});
  Future<Either<ErrorModel, List<ProviderRateModel>>> getProviderRates({required int id});
  Future<Either<ErrorModel,  BaseResponse<List<NotificationModel>>>> getNotifications(int parameters);

}
