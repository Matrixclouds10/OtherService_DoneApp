import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/presentation/component/component.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetails({required this.orderModel, super.key});
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: const CustomText("تفاصيل الطلب").header(),
        isCenterTitle: true,
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListAnimator(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                const SizedBox(height: 0),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ServiceProviderItemWidget(
                    providersModel: ProvidersModel(
                      image: widget.orderModel.provider?.image,
                      name: widget.orderModel.provider?.name,
                      distance: widget.orderModel.provider?.distance,
                      rateAvg: widget.orderModel.provider?.rateAvg,
                    ),
                    showFavoriteButton: false,
                  ),
                ),
                if (widget.orderModel.status.contains("accepted"))
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const CustomText("حالة الطلب", bold: true).headerExtra(),
                            const Spacer(),
                            const CustomText("300 ج", color: Colors.black, bold: true).headerExtra(),
                            // Chip(
                            //   label: CustomText("مكتمل", color: Colors.white).header(),
                            //   backgroundColor: Colors.black,
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            // ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: Colors.black ),
                        textWithDot(text: "وافق مزود الخدمة علي طلبك وبإنتظار ردك بالموافقة علي السعر الأساسي.", color: servicesTheme.colorScheme.secondary),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: CustomButton(
                            onTap: () {},
                            title: "موافقة",
                            fontSize: 18,
                            color: Colors.black ,
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                if (widget.orderModel.status.contains("completed")) ...[
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const CustomText("حالة الطلب", bold: true).headerExtra(),
                            const Spacer(),
                            // CustomText("300 ج", color: Color.fromARGB(255, 230, 35, 35), bold: true).headerExtra(),
                            Chip(
                              label: const CustomText("مكتمل", color: Colors.white).header(),
                              backgroundColor: Colors.black ,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: Colors.black ),
                        textWithDot(text: "وافق مزود الخدمة علي طلبك وبإنتظار ردك بالموافقة علي السعر الأساسي.", color: servicesTheme.colorScheme.secondary),
                        textWithDot(text: "تم التأكيد بواسطتك والطلب قيد التنفيذ.", color: Colors.black),
                        textWithDot(text: "تم الإنتهاء من الطلب وبإنتظار ردك بالموافقة علي السعر النهائي.", color: Colors.black),
                        textWithDot(text: "تم التأكيد بواسطتك وبإنتظار الدفع ", color: Colors.black),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            CustomText("إجمالى البلغ", bold: true, color: servicesTheme.colorScheme.secondary).headerExtra(),
                            const Spacer(),
                            CustomText("300 ج", color: servicesTheme.colorScheme.secondary, bold: true).headerExtra(),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const Divider(height: 2),
                        ...["المبلغ الأساسي", "إضافات مادية ١", "إضافات مادية 2"].map((e) {
                          return Row(
                            children: [
                              Expanded(
                                child: textWithDot(text: e, color: e.contains("المبلغ") ? Colors.black : Colors.black),
                              ),
                              const SizedBox(width: 10),
                              Chip(
                                label: const CustomText("300 ج", color: Colors.white).footer(),
                                backgroundColor: e.contains("المبلغ") ? Colors.black : Colors.black,
                                padding: const EdgeInsets.all(2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              const SizedBox(width: 10),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: CustomButton(
                            onTap: () {},
                            title: "الدفع",
                            fontSize: 18,
                            color: Colors.black,
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
                if (widget.orderModel.status.contains("pending")) ...[
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const CustomText("حالة الطلب", bold: true).headerExtra(),
                            const Spacer(),
                            // CustomText("300 ج", color: Color.fromARGB(255, 230, 35, 35), bold: true).headerExtra(),
                            Chip(
                              label: const CustomText("Pending", color: Colors.white).header(),
                              backgroundColor: Colors.black ,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: Colors.black ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ]
              ],
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
          const SizedBox(width: 5),
          Expanded(child: CustomText(text, color: color, align: TextAlign.start, size: 15)),
        ],
      ),
    );
  }
}
