import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/core/base/base_response.dart';
import 'package:weltweit/features/services/core/base/base_usecase.dart';
import 'package:weltweit/features/services/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/features/services/data/models/response/portfolio/portfolio_image.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import 'package:weltweit/features/services/data/models/response/services/services_response.dart';
import 'package:weltweit/features/services/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/services/update_services_usecase.dart';

abstract class AppRepository {
  //* Auth
  Future<Either<ErrorModel, UserModel>> getProfile();
  Future<Either<ErrorModel, bool>> deleteProfile({required int id});
  Future<Either<ErrorModel, UserModel>> updateAvailability();
  Future<Either<ErrorModel, UserModel>> updateProfile({required UpdateProfileParams params});
  Future<Either<ErrorModel, BaseResponse>> changePassword({required ChangePasswordParams params});

  //* Settings
  Future<Either<ErrorModel, BaseResponse>> updateFcm({required String fcmToken});
  Future<Either<ErrorModel, BaseResponse>> updateLocation({required String lat, required String lng});

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

  Future<Either<ErrorModel, List<OrderModel>>> getOrders({required NoParameters params});
  Future<Either<ErrorModel, OrderModel>> getOrder({required int params});
  Future<Either<ErrorModel, OrderModel>> createOrder({required CreateOrderParams params});
}