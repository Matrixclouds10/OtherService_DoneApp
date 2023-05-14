import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/routing/routes.dart';
import 'package:weltweit/features/provider/presentation/modules/order_details/video_player.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel orderModel; // "completed" or "accepted" or "cancelled"
  const OrderDetails({required this.orderModel, super.key});
  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.orderDetails).header(),
        isCenterTitle: true,
        actions: [
          //chat
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 8),
            iconSize: 22,
            constraints: BoxConstraints(),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            icon: Icon(FontAwesomeIcons.message),
            onPressed: () {
              NavigationService.push(Routes.chatScreen, arguments: {'orderModel': orderModel});
            },
          ),

          //more
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 8),
            iconSize: 22,
            constraints: BoxConstraints(),
            icon: Icon(FontAwesomeIcons.ellipsisVertical),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 180,
              child: DemoVideoPlayer(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListAnimator(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    children: [
                      CustomText(
                        "إصلاح صنبور الماء",
                        pv: 0,
                        bold: true,
                      ).header(),
                    ],
                  ),
                  CustomText(
                    "لدي صنبور نحاسي به مشكلة كبيرة ، وهناك منحدر مائي رهيب. اتمنى لمن لديه حلول مرفقة بك فيديو للمشكلة شكرا لك",
                    align: TextAlign.start,
                    pv: 0,
                  ),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.calendar, size: 16),
                      SizedBox(width: 4),
                      CustomText("07/01/2020 - 3 م : 5 م", pv: 0).footer(),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        decoration: BoxDecoration(color: Color(0xff57A4C3), borderRadius: BorderRadius.circular(4)),
                        child: CustomText("صيانة سباكة", color: Colors.white, size: 14, ph: 8, pv: 0).footer(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.my_location, size: 16),
                      SizedBox(width: 4),
                      CustomText("الرياض ، ميدان سننية، ٨٦ شارع المعتزبالله", pv: 0).footer(),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.route, size: 16),
                      SizedBox(width: 4),
                      CustomText("6 كم", pv: 0).footer(),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            CustomText("حالة الطلب", pv: 0).header(),
                            CustomText("بإنتظار ردك", pv: 0, color: AppColorLight().kAccentColor).footer(),
                          ],
                        ),
                        Spacer(),
                        Transform.rotate(angle: 0.4, child: Icon(Icons.timer, size: 32, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      CustomText(
                        "التكلفة الإجمالية",
                        pv: 0,
                        bold: true,
                      ).header(),
                    ],
                  ),
                  CustomTextFieldNumber(hint: "المبلغ الأساسي", radius: 0),
                  Row(
                    children: const [
                      Spacer(),
                      CustomText("إضافة مبلغ إضافي", pv: 0),
                      SizedBox(width: 12),
                      Icon(Icons.add, size: 30, color: primaryColor),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(width: 16),
                      CustomText("إلغاء").header(),
                      Spacer(),
                      CustomButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        width: 130,
                        title: "تأكيد",
                        color: Colors.black,
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textWithDot({
    required String text,
    Color color = Colors.black54,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5),
          Expanded(child: CustomText(text, color: color, align: TextAlign.start, size: 15)),
        ],
      ),
    );
  }
}
