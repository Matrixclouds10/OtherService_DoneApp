import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/resources/color.dart';

import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("الإشعارات").header(),
        isCenterTitle: true,
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 12),
            ListAnimator(
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < 20; i++)
                  singleCustomListTile(
                    title: getRandomTitle(),
                    desc: getRandomText(),
                    date: getRandomDate(),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget singleCustomListTile({
    required String title,
    required String desc,
    required String date,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.notifications_active, color: Colors.grey, size: 40),
          SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(title,
                      color: Colors.black, align: TextAlign.start, pv: 0),
                  CustomText(
                    date,
                    color: Colors.grey,
                    align: TextAlign.start,
                    pv: 0,
                    size: 12,
                  ),
                ],
              ),
              CustomText(desc,
                  color: Colors.grey, align: TextAlign.start, pv: 0),
            ],
          )),
          SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 24),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  getRandomDate() {
    int year = 2023;
    int month = Random().nextInt(12 - 1) + 1;
    int day = Random().nextInt(30 - 1) + 1;
    return "$day/$month/$year";
  }

  getRandomTitle() {
    List<String> titles = [
      "إشعار جديد",
      "عرض جديد",
      "تنبيه جديد",
    ];
    return titles[Random().nextInt(titles.length)];
  }

  getRandomText() {
    List<String> texts = [
      "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة",
      "يوجد عرض جديد للعملاء الجدد",
      "تنبيه التطبيق يحتاج للتحديث",
      "تنبيه تم تغيير سعر الخدمة"
    ];
    return texts[Random().nextInt(texts.length)];
  }
}
