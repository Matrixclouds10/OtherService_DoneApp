import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

import 'widgets/page_pop_view.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController(initialPage: 0);
  List<PageViewData> pageViewModelData = [];

  late Timer sliderTimer;
  var currentShowIndex = 0;

  @override
  void initState() {
    pageViewModelData.add(PageViewData(
      titleText: LocaleKeys.walkThroughTitle1.tr(),
      subText: LocaleKeys.walkThroughDesc1.tr(),
      assetsImage: Assets.imagesWorkers,
    ));

    pageViewModelData.add(PageViewData(
      titleText: LocaleKeys.walkThroughTitle2.tr(),
      subText: LocaleKeys.walkThroughDesc2.tr(),
      assetsImage: Assets.imagesGps,
    ));
    pageViewModelData.add(PageViewData(
      titleText: LocaleKeys.walkThroughTitle3.tr(),
      subText: LocaleKeys.walkThroughDesc3.tr(),
      assetsImage: Assets.imagesMaps,
    ));

    sliderTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (currentShowIndex == 0) {
        pageController.animateTo(MediaQuery.of(context).size.width, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 1) {
        pageController.animateTo(MediaQuery.of(context).size.width * 2, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 2) {
        pageController.animateTo(MediaQuery.of(context).size.width * 3, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 3) {
        pageController.animateTo(MediaQuery.of(context).size.width * 4, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 4) {
        pageController.animateTo(MediaQuery.of(context).size.width * 5, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 5) {
        pageController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    sliderTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.8),
          image: DecorationImage(
            image: AssetImage(Assets.imagesBk),
            opacity: 0.3,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                pageSnapping: true,
                onPageChanged: (index) {
                  currentShowIndex = index;
                },
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  PagePopup(imageData: pageViewModelData[0]),
                  PagePopup(imageData: pageViewModelData[1]),
                  PagePopup(imageData: pageViewModelData[2]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kScreenPaddingNormal.r),
              child: SmoothPageIndicator(
                controller: pageController, // PageController
                count: 3,
                effect: WormEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.blueGrey,
                  dotHeight: 12.0,
                  dotWidth: 12.0,
                  spacing: 5.0,
                ), // your preferred effect
                onDotClicked: (index) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: kScreenPaddingNormal.h, horizontal: kScreenPaddingLarge.w),
              child: CustomButton(
                title: tr(LocaleKeys.getStarted),
                color: Colors.black,
                onTap: () {
                  AppPrefs prefs = getIt<AppPrefs>();
                  prefs.save(PrefKeys.isFirstTime, false);
                  NavigationService.push(RoutesServices.servicesWelcomeScreen);
                },
              ),
            ),
            VerticalSpace(kScreenPaddingNormal.h)
          ],
        ),
      ),
    );
  }
}
