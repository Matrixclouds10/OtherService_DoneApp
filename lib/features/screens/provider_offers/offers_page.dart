import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/features/core/widgets/offer_item_widget.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("جميع العروض").header(),
        isCenterTitle: true,
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 12),
            ListAnimator(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Image.asset(
                  "assets/images/slider.png",
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
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
        ),
      ),
    );
  }
}
