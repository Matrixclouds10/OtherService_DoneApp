import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/logic/about/about_cubit.dart';
import 'package:weltweit/features/logic/chat/chat_cubit.dart';
import 'package:weltweit/features/logic/contact_us/contact_us_cubit.dart';
import 'package:weltweit/features/logic/home/home_cubit.dart';
import 'package:weltweit/features/logic/policy/policy_cubit.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_portfolio/portfolio_cubit.dart';
import 'package:weltweit/features/logic/provider_service/services_cubit.dart';
import 'package:weltweit/features/logic/provider_subscription/subscription_cubit.dart';
import 'package:weltweit/features/logic/provider_wallet/wallet_cubit.dart';
import 'package:weltweit/features/screens/provider_layout/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/features/logic/banner/banner_cubit.dart';
import 'package:weltweit/features/logic/country/country_cubit.dart';
import 'package:weltweit/features/logic/order/order_cubit.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/screens/auth/login/login_cubit.dart';
import 'package:weltweit/features/screens/auth/otp/otp_cubit.dart';
import 'package:weltweit/features/screens/auth/register/register_cubit.dart';
import 'package:weltweit/features/screens/layout/layout_cubit.dart';
import 'package:weltweit/features/screens/my_addresses/logic/address_cubit.dart';
import 'package:weltweit/features/logic/service/services_cubit.dart';

import 'package:weltweit/features/logic/create_order/create_order_cubit.dart';
import 'package:weltweit/features/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/features/logic/provider/provider/provider_cubit.dart';
import 'package:weltweit/features/logic/provider/provider_services/provider_services_cubit.dart';
import 'package:weltweit/features/logic/provider/providers_cubit.dart';

class GenerateMultiBloc extends StatelessWidget {
  final Widget child;

  const GenerateMultiBloc({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //*user
        BlocProvider(create: (_) => getIt<LoginCubit>()),
        BlocProvider(create: (_) => getIt<RegisterCubit>()),
        BlocProvider(create: (_) => getIt<OtpCubit>()),
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit()),
        BlocProvider<WalletCubit>(create: (BuildContext context) => WalletCubit(getIt())),
        BlocProvider<LayoutCubit>(create: (BuildContext context) => LayoutCubit()),
        //Profile
        BlocProvider<ProfileCubit>(create: (BuildContext context) => ProfileCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt())),
        //Address
        BlocProvider<AddressCubit>(create: (BuildContext context) => AddressCubit(getIt(), getIt(), getIt(), getIt(), getIt())),
        //Services
        BlocProvider<ServicesCubit>(create: (BuildContext context) => ServicesCubit(getIt(), getIt())),
        BlocProvider<ProvidersCubit>(create: (BuildContext context) => ProvidersCubit(getIt(), getIt())),
        BlocProvider<ProviderCubit>(create: (BuildContext context) => ProviderCubit(getIt(), getIt())),
        BlocProvider<ProviderServicesCubit>(create: (BuildContext context) => ProviderServicesCubit(getIt())),
        BlocProvider<FavoriteCubit>(create: (BuildContext context) => FavoriteCubit(getIt(), getIt())),
        BlocProvider<OrdersCubit>(create: (BuildContext context) => OrdersCubit(getIt())),
        BlocProvider<OrderCubit>(
            create: (BuildContext context) => OrderCubit(
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                )),
        BlocProvider<CreateOrderCubit>(create: (BuildContext context) => CreateOrderCubit(getIt())),
        BlocProvider<CountryCubit>(create: (BuildContext context) => CountryCubit(getIt(), getIt())),
        BlocProvider<BannerCubit>(create: (BuildContext context) => BannerCubit(getIt())..getBanner()),
        BlocProvider<SubscribtionCubit>(create: (BuildContext context) => SubscribtionCubit(getIt(), getIt(), getIt())),
        /* -------------------------------------------------------------------------- */
        //*Provider
        BlocProvider<LayoutProviderCubit>(create: (BuildContext context) => LayoutProviderCubit()),
        BlocProvider<ProfileProviderCubit>(create: (BuildContext context) => ProfileProviderCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt())),
        BlocProvider<PortfoliosCubit>(create: (BuildContext context) => PortfoliosCubit(getIt(), getIt(), getIt(), getIt())),
        BlocProvider<ServicesProviderCubit>(create: (BuildContext context) => ServicesProviderCubit(getIt(), getIt())),
        BlocProvider<ChatCubit>(create: (BuildContext context) => ChatCubit(getIt(), getIt())),
        BlocProvider<AboutCubit>(create: (BuildContext context) => AboutCubit(getIt())),
        BlocProvider<PolicyCubit>(create: (BuildContext context) => PolicyCubit(getIt())),
        BlocProvider<ContactUsCubit>(create: (BuildContext context) => ContactUsCubit(getIt())),
        /* -------------------------------------------------------------------------- */

        //DI
      ],
      child: child,
    );
  }
}
