import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/banner/banner_cubit.dart';
import 'package:weltweit/features/logic/home/home_cubit.dart';
import 'package:weltweit/features/screens/home/home_banner.dart';
import 'package:weltweit/features/screens/home/home_most_requested_providers.dart';
import 'package:weltweit/features/screens/home/home_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getCurrentLocationAddress();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.currentLocationAddress.isNotEmpty) {
                      return Expanded(
                        child: Tooltip(
                          message: state.currentLocationAddress,
                          triggerMode: TooltipTriggerMode.tap,
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.black54),
                              Expanded(
                                child: Container(child: CustomText(state.currentLocationAddress, maxLines: 1).footer().start()),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (kDebugMode) {
                      return IconButton(
                          onPressed: () {
                            context.read<HomeCubit>().getCurrentLocationAddress();
                          },
                          icon: const Icon(Icons.refresh));
                    }
                    return Expanded(child: Container());
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesServices.servicesNotifications);
                    },
                    icon: const Icon(Icons.notifications_outlined)),
              ],
            ),
            BlocBuilder<BannerCubit, BannerState>(
              builder: (context, state) {
                if (state.state == BaseState.loaded && state.data.isNotEmpty) return HomeBanner(banners: state.data);
                return Container();
              },
            ),
            const SizedBox(height: 8),
            const HomeServices(key: Key('home_services')),
            const SizedBox(height: 16),
            const MostRequestedProviders(),
            // const SizedBox(height: 16),
            // const HomeOffers(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
