import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/routing/routes.dart';
import 'custom_text.dart';

class OrderItemWidget extends StatelessWidget {
  final String avatar;
  final String name;
  final String profession;
  final String date;
  final String time;
  final String orderStatus;
  final String price;
  final String address;
  final String distanceInKm;
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
    this.address = "",
    this.distanceInKm = "",
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (orderStatus != "cancelled") {
          Navigator.pushNamed(context, RoutesServices.servicesOrderDetails, arguments: {
            "orderStatus": orderStatus,
          });
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(250),
                      child: Image.asset(
                        avatar,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width / 6.4,
                        height: MediaQuery.of(context).size.width / 6.4,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(name, pv: 0),
                        if (profession.isNotEmpty) CustomText(profession, align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                        if (date.isNotEmpty && time.isNotEmpty) CustomText("$date $time", align: TextAlign.start, color: Colors.black, pv: 0).footer(),
                        Wrap(
                          children: [
                            ...tags.map((e) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                decoration: BoxDecoration(color: Color.fromARGB(255, 18, 18, 18), borderRadius: BorderRadius.circular(4)),
                                child: CustomText(e, color: Colors.white, size: 14, ph: 8, pv: 0).footer(),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  if (orderStatus == "cancelled")
                    Column(
                      children: [
                        Icon(Icons.close, color: Colors.red, size: 40),
                        CustomText("عرض السبب", color: Colors.red, pv: 0).footer(),
                      ],
                    ),
                  if (orderStatus != "cancelled")
                    Column(
                      children: [
                        Icon(FontAwesomeIcons.arrowsRotate, size: 36),
                        if (price.isNotEmpty) CustomText(price, color: Colors.orange, pv: 0).header(),
                        if (orderStatus == "pending") CustomText("بإنتظار الموافقة", color: Colors.orange, pv: 0).footer(),
                        if (orderStatus == "accepted") CustomText("قيد التنفيذ", pv: 0).footer(),
                        if (orderStatus == "completed") CustomText("اعطِ تقييم", color: Colors.blueAccent, pv: 0).footer(),
                      ],
                    ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(
                child: Row(
                  children: [
                    if (distanceInKm.isNotEmpty && address.isNotEmpty)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[500], size: 18),
                            Expanded(
                              child: CustomText(address, pv: 0, maxLines: 2, align: TextAlign.start).footer(),
                            ),
                            Icon(Icons.route, color: Colors.grey[500], size: 18),
                            CustomText(distanceInKm, pv: 0).footer(),
                            SizedBox(width: 36),
                          ],
                        ),
                      ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
