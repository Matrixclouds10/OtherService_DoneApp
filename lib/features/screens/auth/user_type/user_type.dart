import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: deviceHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(Assets.imagesAuthBk),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.16),
              CustomImage(imageUrl: Assets.imagesLogo, width: 200),
              Container(
                padding: EdgeInsets.all(kScreenPaddingNormal.r),
                child: ListAnimator(
                  children: [
                    Text(
                      LocaleKeys.joinAs.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle().titleStyle(fontSize: 28).customColor(Colors.white),
                    ),
                    VerticalSpace(kScreenPaddingNormal.h),
                    VerticalSpace(kScreenPaddingNormal.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kScreenPaddingLarge.w),
                      child: CustomButton(
                        title: LocaleKeys.newClient.tr(),
                        onTap: () => NavigationService.push(
                          RoutesServices.servicesRegisterScreen,
                          arguments: {'typeIsProvider': false},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kScreenPaddingLarge.w),
                      child: CustomButton(
                        title: LocaleKeys.serviceProvider.tr(),
                        textColor: Colors.white,
                        color: AppColorLight().kAccentColor,
                        onTap: () => NavigationService.push(
                          RoutesServices.servicesRegisterScreen,
                          arguments: {'typeIsProvider': true},
                        ),
                      ),
                    ),
                    VerticalSpace(kScreenPaddingNormal.h),
                    // GestureDetector(
                    //     onTap: () => NavigationService.push(Routes.servicesHomeScreen),
                    //     child: CustomText(
                    //       LocaleKeys.loginAsVisitor.tr(),
                    //       color: Colors.white,
                    //     )),
                    VerticalSpace(kScreenPaddingNormal.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageViewData {
  final String _titleText;
  final String _subText;
  final String _assetsImage;

  const PageViewData({
    required String titleText,
    required String subText,
    required String assetsImage,
  })  : _titleText = titleText,
        _subText = subText,
        _assetsImage = assetsImage;

  String get assetsImage => _assetsImage;

  String get subText => _subText;

  String get titleText => _titleText;
}
