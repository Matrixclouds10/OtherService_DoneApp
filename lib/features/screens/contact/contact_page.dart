import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/generated/assets.dart';

import 'package:weltweit/presentation/component/component.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int messageType = 1;
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
            Image.asset(Assets.imagesLogo, width: double.infinity, height: 120),
            CustomText(
              "نوع الرسالة",
              align: TextAlign.start,
              pv: 0,
              ph: 16,
            ),
            //Row for two radio buttons
            Row(
              children: [
                //Radio button for user
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                    value: 1,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: CustomText('شكوى', align: TextAlign.start, ph: 0),
                    groupValue: messageType,
                    onChanged: (value) {
                      messageType = 1;
                      setState(() {});
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                    value: 2,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: CustomText('اقتراح', align: TextAlign.start, ph: 0),
                    groupValue: messageType,
                    onChanged: (value) {
                      messageType = 2;
                      setState(() {});
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                    value: 3,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: CustomText('اخرى', align: TextAlign.start, ph: 0),
                    groupValue: messageType,
                    onChanged: (value) {
                      messageType = 3;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),

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
                      Image.asset(Assets.imagesIcCall, width: 70, height: 70),
                      Image.asset(Assets.imagesIcWhats, width: 70, height: 70),
                      Image.asset(Assets.imagesIcFacebook, width: 70, height: 70),
                      Image.asset(Assets.imagesIcTwitter, width: 70, height: 70),
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
