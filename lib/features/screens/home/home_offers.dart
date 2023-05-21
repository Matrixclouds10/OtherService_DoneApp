import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/offer_item_widget.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

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
              child:  CustomText("${LocaleKeys.showAll.tr()}" " (20) ", color: Colors.grey)
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
