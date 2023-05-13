import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/logic/country/country_cubit.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/screens/auth/login/login_cubit.dart';
import 'package:weltweit/features/screens/auth/otp/otp_cubit.dart';
import 'package:weltweit/features/screens/auth/register/register_cubit.dart';
import 'package:weltweit/features/services/logic/create_order/create_order_cubit.dart';
import 'package:weltweit/features/services/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/features/services/logic/order/order_cubit.dart';
import 'package:weltweit/features/services/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/services/logic/provider/provider/provider_cubit.dart';
import 'package:weltweit/features/services/logic/provider/provider_services/provider_services_cubit.dart';
import 'package:weltweit/features/services/logic/provider/providers_cubit.dart';
import 'package:weltweit/features/services/logic/service/services_cubit.dart';
import 'package:weltweit/features/services/modules/layout/layout_cubit.dart';
import 'package:weltweit/features/services/modules/my_addresses/logic/address_cubit.dart';

import 'provider/logic/subscription/subscription_cubit.dart';
import 'services/logic/banner/banner_cubit.dart';

final List<dynamic> kServicesProviders = [
  BlocProvider(create: (_) => getIt<LoginCubit>()),
  BlocProvider(create: (_) => getIt<RegisterCubit>()),
  BlocProvider(create: (_) => getIt<OtpCubit>()),

  BlocProvider<LayoutCubit>(create: (BuildContext context) => LayoutCubit()),

  //Profile
  BlocProvider<ProfileCubit>(
      create: (BuildContext context) => ProfileCubit(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
          )),

  //Address
  BlocProvider<AddressCubit>(
      create: (BuildContext context) => AddressCubit(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
          )),

  //Services
  BlocProvider<ServicesCubit>(create: (BuildContext context) => ServicesCubit(getIt(), getIt())),
  BlocProvider<ProvidersCubit>(create: (BuildContext context) => ProvidersCubit(getIt(),getIt())),
  BlocProvider<ProviderCubit>(create: (BuildContext context) => ProviderCubit(getIt())),
  BlocProvider<ProviderServicesCubit>(create: (BuildContext context) => ProviderServicesCubit(getIt())),
  BlocProvider<FavoriteCubit>(create: (BuildContext context) => FavoriteCubit(getIt(), getIt())),
  BlocProvider<OrdersCubit>(create: (BuildContext context) => OrdersCubit(getIt())),
  BlocProvider<OrderCubit>(create: (BuildContext context) => OrderCubit(getIt(), getIt())),
  BlocProvider<CreateOrderCubit>(create: (BuildContext context) => CreateOrderCubit(getIt())),
  BlocProvider<CountryCubit>(create: (BuildContext context) => CountryCubit(getIt(),getIt())),
  BlocProvider<BannerCubit>(create: (BuildContext context) => BannerCubit(getIt())..getBanner()),
  BlocProvider<SubscriptionCubit>(create: (BuildContext context) => SubscriptionCubit(getIt())),
];
