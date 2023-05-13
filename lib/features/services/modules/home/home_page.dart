import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/services/domain/usecase/provider/most_requested_providers_usecase.dart';
import 'package:weltweit/features/services/logic/banner/banner_cubit.dart';
import 'package:weltweit/features/services/modules/home/home_banner.dart';
import 'package:weltweit/features/services/modules/home/home_most_requested_providers.dart';
import 'package:weltweit/features/services/modules/home/home_offers.dart';
import 'package:weltweit/features/services/modules/home/home_services.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      // appBar: ServicesAppBar(
      //   isBackButtonExist: false,
      //   leading: Container(
      //     decoration: BoxDecoration().customColor(servicesTheme.primaryColor).radius(radius: 4),
      //     child: CustomText("Location"),
      //   ),
      //   actions: [
      //     IconButton(onPressed: () {}, icon: Icon(Icons.search)),
      //     IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Row(
              children: [
                // Container(
                //   decoration: const BoxDecoration().customColor(servicesTheme.primaryColor).radius(radius: 4),
                //   child: const CustomText("الرياض", color: Colors.white),

                // ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesServices.servicesNotifications);
                    },
                    icon: const Icon(Icons.notifications_outlined)),
              ],
            ),
            BlocBuilder<BannerCubit, BannerState>(
              builder: (context, state) {
                if (state.state == BaseState.loaded) return HomeBanner(banners: state.data);
                return Container();
              },
            ),
            const HomeServices(
              key: Key('home_services'),
            ),
            const SizedBox(height: 16),
            const MostRequestedProviders(),
            const SizedBox(height: 16),
            const HomeOffers(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
