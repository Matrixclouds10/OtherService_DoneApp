import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/services/logic/create_order/create_order_cubit.dart';
import 'package:weltweit/features/services/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/features/services/logic/order/order_cubit.dart';
import 'package:weltweit/features/services/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/services/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/services/logic/provider/provider/provider_cubit.dart';
import 'package:weltweit/features/services/logic/provider/provider_services/provider_services_cubit.dart';
import 'package:weltweit/features/services/logic/provider/providers_cubit.dart';
import 'package:weltweit/features/services/logic/service/services_cubit.dart';
import 'package:weltweit/features/services/modules/auth/login/login_cubit.dart';
import 'package:weltweit/features/services/modules/auth/otp/otp_cubit.dart';
import 'package:weltweit/features/services/modules/auth/register/register_cubit.dart';
import 'package:weltweit/features/services/modules/layout/layout_cubit.dart';

final List<dynamic> kServicesProviders = [
  BlocProvider(create: (_) => getIt<LoginCubit>()),
  BlocProvider(create: (_) => getIt<RegisterCubit>()),
  BlocProvider(create: (_) => getIt<OtpCubit>()),

  BlocProvider<LayoutCubit>(create: (BuildContext context) => LayoutCubit()),

  //Profile
  BlocProvider<ProfileCubit>(create: (BuildContext context) => ProfileCubit(getIt(), getIt(), getIt(), getIt(), getIt())),

  //Services
  BlocProvider<ServicesCubit>(create: (BuildContext context) => ServicesCubit(getIt(), getIt())),
  BlocProvider<ProvidersCubit>(create: (BuildContext context) => ProvidersCubit(getIt())),
  BlocProvider<ProviderCubit>(create: (BuildContext context) => ProviderCubit(getIt())),
  BlocProvider<ProviderServicesCubit>(create: (BuildContext context) => ProviderServicesCubit(getIt())),
  BlocProvider<FavoriteCubit>(create: (BuildContext context) => FavoriteCubit(getIt(), getIt())),
  BlocProvider<OrdersCubit>(create: (BuildContext context) => OrdersCubit(getIt())),
  BlocProvider<OrderCubit>(create: (BuildContext context) => OrderCubit(getIt())),
  BlocProvider<CreateOrderCubit>(create: (BuildContext context) => CreateOrderCubit(getIt())),
];
