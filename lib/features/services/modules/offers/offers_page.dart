import 'package:flutter/material.dart';
import 'package:weltweit/features/services/core/widgets/offer_item_widget.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: const CustomText("جميع العروض").header(),
        isCenterTitle: true,
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 12),
            ListAnimator(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Image.asset(
                  Assets.imagesSlider,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                for (var i = 0; i < 4; i++)
                  const OfferItemWidget(
                    imageUrl: Assets.imagesOfferImage,
                    title: "عرض الصيف",
                    description:
                        "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة",
                    isFavorite: false,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
