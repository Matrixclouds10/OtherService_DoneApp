import 'package:flutter_svg/svg.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import '../../../generated/locale_keys.g.dart';
import '../../core/resources/text_styles.dart';
import '../../core/resources/values_manager.dart';
import 'component.dart';

class NoDataScreen extends StatelessWidget {
  final String? _title;
  final String? _desc;
  final String _image;
  final String? _imageSvg;

  const NoDataScreen({
    super.key,
    String? title,
    String? desc,
    String image = Assets.imagesGifEmptyList,
    String? imageSvg,
  })  : _title = title,
        _desc = desc,
        _image = image,
        _imageSvg = imageSvg;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kFormPaddingHorizontal.r),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_imageSvg != null)
            SvgPicture.asset(
              _imageSvg!,
              width: 150.r,
              height: 150.r,
            )
          else
            Image.asset(
              _image,
              width: 150.r,
              height: 150.r,
            ),
          const SizedBox(height: kFormPaddingHorizontal),
          Text(
            _title ?? tr(LocaleKeys.noResultFound),
            style: const TextStyle().regularStyle(),
            textAlign: TextAlign.center,
          ),
          VerticalSpace(kScreenPaddingNormal.h),
          Text(
            _desc ?? '',
            style: const TextStyle().regularStyle().hintStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kScreenPaddingNormal),
        ]),
      ),
    );
  }
}

// class NoDataScreen extends StatelessWidget {
//   final String  title;
//   final String? desc;
//   final String image;
//   const NoDataScreen({Key? key, this.title = ,  this.desc ,  this.image = Assets.gifEmptyList}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Padding(
//       padding:  EdgeInsets.all(kFormPaddingHorizontal.r),
//       child: Center(
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Image.asset(image, width:200.r, height: 200.r),
//
//           Text(
//               title?? tr(LocaleKeys.noResultFound),
//             style: const TextStyle().titleStyle(),
//             textAlign: TextAlign.center,
//           ),
//            VerticalSpace(kScreenPaddingNormal.h),
//
//
//           Text(
//             desc??'',
//             style: const TextStyle().descriptionStyle().hintStyle(),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: kScreenPaddingNormal),
//
//         ]),
//       ),
//     );
//   }
// }
