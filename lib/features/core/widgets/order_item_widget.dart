import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weltweit/core/extensions/widget_extensions.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/logic/order/order_cubit.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
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
              padding: EdgeInsets.all(4),
              margin: const EdgeInsets.only(top: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: CustomImage(
                  imageUrl: orderModel.provider?.image ?? '',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width / 6.6,
                  height: MediaQuery.of(context).size.width / 6.6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(orderModel.provider?.name ?? '', pv: 0, bold: true),
                  SizedBox(height: 2),
                  _dateWidget(date, time),
                  if (date.isNotEmpty && time.isNotEmpty) ...[],
                  SizedBox(height: 2),
                  SizedBox(height: 2),
                  if (orderModel.service != null)
                    Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          decoration: BoxDecoration(color: servicesTheme.colorScheme.secondary, borderRadius: BorderRadius.circular(4)),
                          child: CustomText(orderModel.service!.title ?? '', color: Colors.white, size: 14, ph: 8, pv: 2).footer(),
                        ),
                      ],
                    ),
                  SizedBox(height: 2),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _statusWidget(),
            const SizedBox(width: 4),
          ],
        ));
  }

  _statusWidget() {
    return Builder(builder: (context) {
      return Column(
        children: [
          if (orderModel.statusCode?.toLowerCase() == "cancelled") Icon(Icons.close, color: Colors.red, size: 40),
          if (orderModel.statusCode?.toLowerCase() == "pending") CustomText(LocaleKeys.waitingForApproval.tr(), color: servicesTheme.primaryColor, pv: 0).footer(),
          if (orderModel.statusCode?.toLowerCase() == "provider_accept") CustomText(LocaleKeys.approved.tr(), color: Colors.green, pv: 0).footer(),
          if (orderModel.statusCode?.toLowerCase() == "provider_finish") CustomText(LocaleKeys.finished.tr(), pv: 0).footer(),
          if (orderModel.statusCode?.toLowerCase() == "client_done") ...[
            if (orderModel.rate == null)
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(4),
                child: CustomText(LocaleKeys.giverate.tr(), color: Colors.blueAccent, pv: 0).footer(),
              ).onTap(() {
                AppDialogs().rateOrderDialog(context, orderModel);
              }),
            if (orderModel.rate != null)
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(4),
                child: Column(
                  children: [
                    CustomText(LocaleKeys.youRated.tr(), color: Colors.blueAccent, pv: 0).footer(),
                    if(orderModel.rate?.rate != null)
                    Row(
                      children: [
                        for (var i = 0; i < orderModel.rate!.rate!; i++) const Icon(Icons.star, size: 12, color: Colors.yellow),
                        for (var i = 0; i < 5 - orderModel.rate!.rate!; i++) const Icon(Icons.star, size: 12, color: Colors.grey),
                      ],
                    )
                  ],
                ),
              ).onTap(() {
                AppDialogs().rateOrderDialog(context, orderModel);
              }),
          ]
        ],
      );
    });
  }

  _dateWidget(String date, String time) {
    return Row(
      children: [
        FaIcon(Icons.calendar_today, color: Colors.grey, size: 16),
        CustomText(date, align: TextAlign.start, color: Colors.black, pv: 0).footer(),
        const SizedBox(width: 4),
        FaIcon(Icons.access_time, color: Colors.grey, size: 16),
        CustomText(time, align: TextAlign.start, color: Colors.black, pv: 0).footer(),
      ],
    );
  }
}
