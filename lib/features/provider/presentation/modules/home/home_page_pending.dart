import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';

import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class HomePageInActive extends StatelessWidget {
  const HomePageInActive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(Assets.imagesPending, height: 200, width: 200),
          SizedBox(height: 12),
          CustomText(LocaleKeys.yourAccountInReview.tr(),
                  color: AppColorLight().kAccentColor)
              .header(),
          ...[
            LocaleKeys.makeSureToUploadAllFiles.tr(),
          ]
              .map((e) => AppTextTile(
                    title: CustomText(
                      e,
                      size: 16,
                      pv: 0,
                      align: TextAlign.start,
                    ),
                    isTitleExpanded: true,
                    leading: Icon(Icons.circle, size: 12),
                  ))
              .toList(),
          SizedBox(height: 32),
          CustomButton(
            onTap: () {
              Navigator.of(context).pushNamed(RoutesProvider.providerDocuments);
            },
            expanded: false,
            isOutlined: true,
            child: CustomText(LocaleKeys.goToMyFiles.tr(),
                color: primaryColor, ph: 30, bold: true),
          ),
          SizedBox(height: 32),
          Stack(
            children: [
              Divider(height: 40),
              Positioned(
                child: Center(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      color: AppColorLight().kScaffoldBackgroundColor,
                      child: CustomText(LocaleKeys.toContactUs.tr())),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(Assets.imagesIcCall, width: 70, height: 70),
              Image.asset(Assets.imagesIcWhats, width: 70, height: 70),
              Image.asset(Assets.imagesIcFacebook, width: 70, height: 70),
              Image.asset(Assets.imagesIcTwitter, width: 70, height: 70),
            ],
          )
        ]),
      ),
    );
  }
}
