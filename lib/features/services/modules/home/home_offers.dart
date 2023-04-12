import 'package:flutter/material.dart';
import 'package:weltweit/features/services/core/routing/routes.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/core/widgets/offer_item_widget.dart';
import 'package:weltweit/generated/assets.dart';

class HomeOffers extends StatelessWidget {
  const HomeOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CustomText("عروض اليوم", color: Colors.black54).footer(),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesServices.servicesOffers);
              },
              child: const CustomText("عرض الكل" " (20) ", color: Colors.grey)
                  .footerExtra(),
            ),
          ],
        ),
        Container(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 0; i < 4; i++)
                const OfferItemWidget(
                  imageUrl: Assets.imagesOfferImage,
                  title: "عرض الصيف",
                  description:
                      "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة",
                  isFavorite: false,
                ),
            ],
          ),
        )
      ],
    );
  }
}