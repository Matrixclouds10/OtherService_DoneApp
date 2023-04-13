import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/presentation/component/images/custom_image.dart';

class OrderItemWidget extends StatelessWidget {
  final String avatar;
  final String name;
  final String profession;
  final String date;
  final String time;
  final String orderStatus;
  final String price;
  final List<String> tags;

  const OrderItemWidget({
    required this.avatar,
    required this.name,
    required this.profession,
    required this.date,
    required this.time,
    required this.orderStatus,
    required this.price,
    required this.tags,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
  return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                child: CustomImage(
                  imageUrl: avatar,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width / 6.4,
                  height: MediaQuery.of(context).size.width / 6.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(name, pv: 0),
                  CustomText(profession,
                          align: TextAlign.start,
                          color: Colors.grey[500]!,
                          pv: 0)
                      .footer(),
                  if (date.isNotEmpty && time.isNotEmpty)
                    CustomText("$date $time",
                            align: TextAlign.start,
                            color: Colors.black,
                            pv: 0)
                        .footer(),
                  Wrap(
                    children: [
                      ...tags.map((e) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
                          decoration: BoxDecoration(
                              color: servicesTheme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(4)),
                          child: CustomText(e,
                                  color: Colors.white, size: 14, ph: 8, pv: 0)
                              .footer(),
                        );
                      }).toList(),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (orderStatus == "cancelled")
              const Icon(Icons.close, color: Colors.red, size: 40),
            if (orderStatus != "cancelled")
              Column(
                children: [
                  if (price.isNotEmpty)
                    CustomText(price,
                            color: servicesTheme.primaryColor, pv: 0)
                        .header(),
                  if (orderStatus == "pending")
                    CustomText("بإنتظار الموافقة",
                            color: servicesTheme.primaryColor, pv: 0)
                        .footer(),
                  if (orderStatus == "accepted")
                    const CustomText("قيد التنفيذ", pv: 0).footer(),
                  if (orderStatus == "completed")
                    const CustomText("اعطِ تقييم",
                            color: Colors.blueAccent, pv: 0)
                        .footer(),
                ],
              ),
            const SizedBox(width: 8),
          ],
        ));
  }
}
