import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/presentation/component/images/custom_image.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderItemWidget({
    required this.orderModel,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyy-MM-dd').format(orderModel.date);
    String time = DateFormat('HH:mm').format(orderModel.date);
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
                  imageUrl: orderModel.provider?.image ?? '',
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
                  CustomText(orderModel.provider?.name ?? '', pv: 0),
                  if (date.isNotEmpty && time.isNotEmpty) CustomText("$date $time", align: TextAlign.start, color: Colors.black, pv: 0).footer(),
                  if (orderModel.service != null)
                    Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          decoration: BoxDecoration(color: servicesTheme.colorScheme.secondary, borderRadius: BorderRadius.circular(4)),
                          child: CustomText(orderModel.service!.title ?? '', color: Colors.white, size: 14, ph: 8, pv: 0).footer(),
                        ),
                      ],
                    )
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (orderModel.status.toLowerCase() == "cancelled") const Icon(Icons.close, color: Colors.red, size: 40),
            if (orderModel.status.toLowerCase() != "cancelled")
              Column(
                children: [
                  // if (orderModel..isNotEmpty) CustomText(price, color: servicesTheme.primaryColor, pv: 0).header(),
                  if (orderModel.status.toLowerCase() == "pending") CustomText("بإنتظار الموافقة", color: servicesTheme.primaryColor, pv: 0).footer(),
                  if (orderModel.status.toLowerCase() == "accepted") const CustomText("قيد التنفيذ", pv: 0).footer(),
                  if (orderModel.status.toLowerCase() == "completed") const CustomText("اعطِ تقييم", color: Colors.blueAccent, pv: 0).footer(),
                ],
              ),
            const SizedBox(width: 8),
          ],
        ));
  }
}
