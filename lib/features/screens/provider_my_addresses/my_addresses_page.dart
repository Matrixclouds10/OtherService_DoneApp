import 'package:flutter/material.dart';

import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class MyAddressesPage extends StatelessWidget {
  const MyAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.myAddresses.tr()).header(),
        isCenterTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
        child: SingleChildScrollView(
          child: ListAnimator(
            children: [
              SizedBox(height: 12),
              for (int i = 0; i < 10; i++)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: CustomText("الرياض ",
                                          align: TextAlign.start)
                                      .header()),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Color(0xff57A4C3),
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                          CustomText(
                              "ميدان سننية، ٨٦ شارع المعتزبالله، ٣٤٣٤٧٧"),
                          //make default address
                          Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                value: i == 0,
                                fillColor:
                                    MaterialStateProperty.all(Colors.orange),
                                onChanged: (value) {},
                              ),
                              CustomText("تعيين كعنوان افتراضي"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
