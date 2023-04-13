import 'dart:math';

import 'package:flutter/material.dart';

import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import '../home/home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 12),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back, color: primaryColor),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      SizedBox(width: 4),
                      Expanded(
                          child: CustomTextFieldSearch(
                        controller: _searchController,
                        onChange: (value) {
                          setState(() {});
                        },
                      )),
                      SizedBox(width: 4),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                            icon: Icon(Icons.close, color: Colors.black54),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            }),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
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
