import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/presentation/component/component.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: const CustomText("الإشعارات").header(),
        isCenterTitle: true,
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 12),
            ListAnimator(
              physics: const NeverScrollableScrollPhysics(),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.grey, size: 40),
          const SizedBox(width: 12),
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
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios,
              color: servicesTheme.primaryColorLight, size: 24),
          const SizedBox(width: 12),
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
