import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/generated/assets.dart';

import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("تواصل معنا").header(),
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListAnimator(
          physics: NeverScrollableScrollPhysics(),
          children: [
            //Log
            Image.asset(
              "assets/images/placeholder.jpg",
              width: double.infinity,
              fit: BoxFit.cover,
              height: 120,
            ),
            SizedBox(height: 12),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomTextFieldNormal(hint: "الاسم"),
                  SizedBox(height: 12),
                  CustomTextFieldEmail(hint: "البريد الالكتروني"),
                  SizedBox(height: 12),
                  CustomTextFieldArea(hint: "الرسالة"),
                  SizedBox(height: 12),
                  CustomButton(
                    onTap: () {},
                    title: "ارسال",
                    color: Colors.black,
                  ),
                  SizedBox(height: 8),
                  Stack(
                    children: [
                      Divider(height: 40),
                      Positioned(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            color: AppColorLight().kScaffoldBackgroundColor,
                            child: CustomText("او"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(Assets.imagesIcCall, width: 70, height: 70),
                      Image.asset(Assets.imagesIcWhats, width: 70, height: 70),
                      Image.asset(Assets.imagesIcFacebook,
                          width: 70, height: 70),
                      Image.asset(Assets.imagesIcTwitter,
                          width: 70, height: 70),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
