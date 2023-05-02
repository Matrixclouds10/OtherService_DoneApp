import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/services/data/models/response/chat/chat_model.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/features/services/data/models/response/portfolio/portfolio_image.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import 'package:weltweit/features/services/data/models/response/services/services_response.dart';
import 'package:weltweit/features/domain/usecase/chat_messages/chat_messages_usecase.dart';
import 'package:weltweit/features/domain/usecase/chat_send_message/chat_send_message_usecase.dart';
import 'package:weltweit/features/domain/usecase/contact_us/contact_us_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/order_cancel/order_cancel_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/orders/orders_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/services/update_services_usecase.dart';

abstract class AppRepository {
  //* Auth
  Future<Either<ErrorModel, UserModel>> getProfile();
  Future<Either<ErrorModel, bool>> deleteProfile({required int id});
  Future<Either<ErrorModel, UserModel>> updateProfile({required UpdateProfileParams params});
  Future<Either<ErrorModel, BaseResponse>> changePassword({required ChangePasswordParams params});

  //* Settings
  Future<Either<ErrorModel, BaseResponse>> updateFcm({required String fcmToken});

  //* Services
  Future<Either<ErrorModel, ServicesResponse>> getAllServices({required int page});
  Future<Either<ErrorModel, List<ServiceModel>>> updateMyServices({required UpdateServicesParams params});

  //* Providers
  Future<Either<ErrorModel, List<ProvidersModel>>> getProviders({required ProvidersParams params});
  Future<Either<ErrorModel, ProvidersModel>> getProvider({required int id});
  Future<Either<ErrorModel, List<ServiceModel>>> getProviderServices({required int id});
  Future<Either<ErrorModel, List<PortfolioModel>>> getProviderPortfolio({required int id});

  //*Favorites
  Future<Either<ErrorModel, BaseResponse>> addToFavorites({required int id});
  Future<Either<ErrorModel, BaseResponse>> removeFromFavorites({required int id});
  Future<Either<ErrorModel, List<ProvidersModel>>> getFavorites();

  Future<Either<ErrorModel, List<OrderModel>>> getOrders({required OrdersParams params});
  Future<Either<ErrorModel, OrderModel>> getOrder({required int params});
  Future<Either<ErrorModel, OrderModel>> createOrder({required CreateOrderParams params});
  Future<Either<ErrorModel, BaseResponse>> cancelOrder({required OrderCancelParams params});

  Future<Either<ErrorModel, String>> getAbout();
  Future<Either<ErrorModel, String>> getPolicy();
  Future<Either<ErrorModel, BaseResponse>> sendContactUs({required ContactUsParams params});
  Future<Either<ErrorModel, BaseResponse>> sendChatMessage({required ChatSendMessageParams params});
  Future<Either<ErrorModel, List<ChatModel>>> getChatMessages({required ChatMessagesParams params});
}
