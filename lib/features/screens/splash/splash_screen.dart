import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/firebase_methods.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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
      FirebaseMethods firebaseMethods = FirebaseMethods();
      bool status = await firebaseMethods.hideForIos();
      AppPrefs prefs = getIt<AppPrefs>();
      prefs.save(PrefKeys.iosStatus, status);
      bool isOnBoarding = prefs.get(PrefKeys.isFirstTime, defaultValue: true);
      String? token = prefs.get(PrefKeys.token, defaultValue: null);
      bool typeIsProvider = prefs.get(PrefKeys.isTypeProvider, defaultValue: false);
      if (isOnBoarding) {
        NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesOnBoardingScreen);
      } else if (token != null) {
        if (typeIsProvider) {
          NavigationService.pushNamedAndRemoveUntil(RoutesProvider.providerLayoutScreen);
        } else {
          NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesLayoutScreen);
        }
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
          children: [
            Spacer(),
            Spacer(),
            CustomImage(imageUrl: Assets.imagesLogo),
            SizedBox(height: 20),
            CustomImage(
              imageUrl: Assets.imagesMaps,
              width: deviceWidth / 1.4,
              height: deviceWidth / 1.4,
            ),
            Spacer(),
            CustomLoadingSpinner(size: 45),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
