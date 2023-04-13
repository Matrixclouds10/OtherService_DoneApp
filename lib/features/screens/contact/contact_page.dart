import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/generated/assets.dart';

import 'package:weltweit/presentation/component/component.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: const CustomText("تواصل معنا").header(),
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListAnimator(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            //Log
            Image.asset(
              Assets.imagesPlaceholder,
              width: double.infinity,
              fit: BoxFit.cover,
              height: 120,
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomTextFieldNormal(hint: "الاسم"),
                  const SizedBox(height: 12),
                  const CustomTextFieldEmail(hint: "البريد الالكتروني"),
                  const SizedBox(height: 12),
                  const CustomTextFieldArea(hint: "الرسالة"),
                  const SizedBox(height: 12),
                  CustomButton(
                    onTap: () {},
                    title: "ارسال",
                    color: servicesTheme.primaryColorLight,
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      const Divider(height: 40),
                      Positioned(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            color: servicesTheme.scaffoldBackgroundColor,
                            child: const CustomText("او"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(Assets.imagesIcCall,
                          width: 70, height: 70),
                      Image.asset(Assets.imagesIcWhats,
                          width: 70, height: 70),
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
