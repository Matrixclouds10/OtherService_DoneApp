import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/presentation/component/spaces.dart';

class PagePopup extends StatelessWidget {
  final PageViewData imageData;

  const PagePopup({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 40),
        Image.asset(
          imageData.assetsImage,
          fit: BoxFit.fitHeight,
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 1.5,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.all(kScreenPaddingNormal.r),
            child: Column(
              children: [
                VerticalSpace(kScreenPaddingLarge.h),
                VerticalSpace(kScreenPaddingLarge.h),
                Text(
                  tr(imageData.titleText),
                  textAlign: TextAlign.center,
                  style: const TextStyle().titleStyle(fontSize: 28).customColor(Colors.white),
                ),
                VerticalSpace(kScreenPaddingLarge.h),
                Text(
                  tr(imageData.subText),
                  textAlign: TextAlign.center,
                  style: const TextStyle().customColor(Colors.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PageViewData {
  final String _titleText;
  final String _subText;
  final String _assetsImage;

  const PageViewData({
    required String titleText,
    required String subText,
    required String assetsImage,
  })  : _titleText = titleText,
        _subText = subText,
        _assetsImage = assetsImage;

  String get assetsImage => _assetsImage;

  String get subText => _subText;

  String get titleText => _titleText;
}
