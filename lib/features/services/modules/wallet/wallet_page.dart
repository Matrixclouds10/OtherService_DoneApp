import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';


class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBar(
          isBackButtonExist: false,
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: CustomText("مصروفاتي").header(),
          actions: const [],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesBk2),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              CustomText("980.00", color: Colors.white, align: TextAlign.start, pv: 0, ph: 12, size: 28),
              CustomText("إجمالي المصروفات", color: Colors.white, align: TextAlign.start, pv: 0, ph: 12),
              SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      CustomText("عمليات الدفع السابقة", color: Colors.black, align: TextAlign.start, pv: 0, ph: 12).header(),
                      for (var i = 0; i < 4; i++)
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(250),
                                    child: Image.asset(Assets.imagesAvatar,
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width / 7,
                                      height: MediaQuery.of(context).size.width / 7,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText("مسعد معوض", pv: 2),
                                      CustomText("#33215", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                                    ],
                                  ),
                                ),
                                CustomText("120.00 ج", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                                SizedBox(width: 8),
                              ],
                            )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
