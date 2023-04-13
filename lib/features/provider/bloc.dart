import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/provider/logic/portfolio/portfolio_cubit.dart';
import 'package:weltweit/features/provider/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/provider/logic/service/services_cubit.dart';
import 'package:weltweit/features/provider/presentation/modules/layout/layout_cubit.dart';

final List<dynamic> kProviderBloc = [

  
        BlocProvider<LayoutProviderCubit>(create: (BuildContext context) => LayoutProviderCubit()),

        //Profile
        BlocProvider<ProfileProviderCubit>(
            create: (BuildContext context) => ProfileProviderCubit(
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                )),

        BlocProvider<PortfoliosCubit>(create: (BuildContext context) => PortfoliosCubit(getIt(), getIt(), getIt(), getIt())),
        BlocProvider<ServicesProviderCubit>(create: (BuildContext context) => ServicesProviderCubit(getIt(), getIt())),

];
