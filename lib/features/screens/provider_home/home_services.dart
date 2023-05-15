import 'package:flutter/material.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/service_item_widget.dart';
import 'package:weltweit/features/data/models/services/service.dart';

class HomeServices extends StatelessWidget {
  const HomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomText("الخدمات", color: Colors.black54).footer(),
            Spacer(),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesProvider.providerServices);
                },
                child: CustomText("عرض الكل" " (20) ", color: Colors.grey).footer()),
          ],
        ),
        Container(
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: [
              for (var i = 0; i < 8; i++)
                ServiceItemWidget(
                  width: double.infinity,
                  grid: true,
                  serviceModel: ServiceModel(
                    id: 1,
                    breif: "مساعدة في الحصول على الوظيفة",
                    title: "التوظيف",
                    myService: false,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
