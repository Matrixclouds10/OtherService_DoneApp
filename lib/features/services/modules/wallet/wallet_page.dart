import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffE67E23),
        appBar: CustomAppBar(
          isBackButtonExist: false,
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: const CustomText("محفظتي").header(),
          actions: const [],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const CustomText("980.00",
                color: Colors.white,
                align: TextAlign.start,
                pv: 0,
                ph: 12,
                size: 28),
            const CustomText("إجمالي المبلغ",
                color: Colors.white, align: TextAlign.start, pv: 0, ph: 12),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: servicesTheme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const CustomText("عمليات الدفع السابقة",
                            color: Colors.black,
                            align: TextAlign.start,
                            pv: 0,
                            ph: 12)
                        .header(),
                    for (var i = 0; i < 4; i++)
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(250),
                                  child: Image.asset(
                                    Assets.imagesAvatar,
                                    fit: BoxFit.fill,
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    height:
                                        MediaQuery.of(context).size.width / 7,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText("مسعد معوض", pv: 2),
                                    CustomText("#33215",
                                            align: TextAlign.start,
                                            color: Colors.grey[500]!,
                                            pv: 0)
                                        .footer(),
                                  ],
                                ),
                              ),
                              CustomText("120.00 ج",
                                      align: TextAlign.start,
                                      color: Colors.grey[500]!,
                                      pv: 0)
                                  .footer(),
                              const SizedBox(width: 8),
                            ],
                          )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
