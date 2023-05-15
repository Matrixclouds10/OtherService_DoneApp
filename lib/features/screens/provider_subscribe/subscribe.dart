import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class SubscribePage extends StatelessWidget {
  const SubscribePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("تفعيل الحساب").header(),
        isCenterTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBk2),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: ListAnimator(
            children: [
              SizedBox(height: 24),
              Image.asset(
                Assets.imagesLogo,
                height: 120,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 12),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                decoration:
                    BoxDecoration(color: Colors.white).radius(radius: 12),
                child: Column(
                  children: [
                    CustomText("فعل حسابك واحصل علي تجربة عمل مميزة ",
                            color: primaryColor)
                        .header(),
                    CustomText("300 ج", color: AppColorLight().kAccentColor)
                        .headerExtra(),
                    CustomText("سنويا", color: Colors.grey[500]!, pv: 0)
                        .headerExtra(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        onTap: () {
                          NavigationService.goBack();
                        },
                        title: "إشترك الان",
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("assets/images/ic_call.png",
                      width: 70, height: 70),
                  Image.asset("assets/images/ic_whats.png",
                      width: 70, height: 70),
                  Image.asset("assets/images/ic_facebook.png",
                      width: 70, height: 70),
                  Image.asset("assets/images/ic_twitter.png",
                      width: 70, height: 70),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
