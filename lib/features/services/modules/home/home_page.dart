import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/modules/home/home_offers.dart';
import 'package:weltweit/features/services/modules/home/home_services.dart';
import 'package:weltweit/generated/assets.dart';

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
            Image.asset(Assets.imagesSlider, width: double.infinity, fit: BoxFit.fill),
            const HomeServices(),
            const SizedBox(height: 16),
            const HomeOffers(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
