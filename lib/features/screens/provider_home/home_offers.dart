import 'package:flutter/material.dart';

import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/offer_item_widget.dart';

class HomeOffers extends StatelessWidget {
  const HomeOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomText("عروض اليوم", color: Colors.black54).footer(),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesProvider.providerOffers);
              },
              child:
                  CustomText("عرض الكل" " (20) ", color: Colors.grey).footer(),
            ),
          ],
        ),
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < 4; i++)
              OfferItemWidget(
                imageUrl: "assets/images/offer_image.png",
                title: "عرض الصيف",
                description:
                    "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة",
                isFavorite: false,
              ),
          ],
        )
      ],
    );
  }
}
