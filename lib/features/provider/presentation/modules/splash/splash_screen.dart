import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/features/provider/data/injection.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';

import 'package:weltweit/core/routing/navigation_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  _playAnimation() async {
    Timer(const Duration(seconds: 1), () async {
      _route();
    });
  }

  @override
  void initState() {
    super.initState();
    _playAnimation();
  }

  void _route() async {
    Timer(const Duration(seconds: 2), () async {
      AppPrefs prefs = getIt<AppPrefs>();
      bool isOnBoarding = prefs.get(PrefKeys.isFirstTime, defaultValue: true);
      String? token = prefs.get(PrefKeys.token, defaultValue: null);
      if (isOnBoarding) {
        NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesOnBoardingScreen);
      } else if (token != null) {
        NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesLayoutScreen);
      } else {
        NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesWelcomeScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(Assets.imagesBk),
            fit: BoxFit.cover,
          ),
        ),
        width: deviceWidth,
        height: deviceHeight,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(),
            CustomImage(imageUrl: Assets.imagesLogo),
            Spacer(),
            CustomLoadingSpinner(size: 45),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
