import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/widgets/app_text_tile.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class AppBottomSheets {
  pickImage({required Function(File file) callback}) async {
    Dialogs.bottomMaterialDialog(
      msg: LocaleKeys.selectImageSource.tr(),
      color: Colors.white,
      context: NavigationService.navigationKey.currentContext!,
      actions: [
        IconsOutlineButton(
          onPressed: () async {
            XFile? pickedFile = await (ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 33));
            if (pickedFile != null) {
              callback(File(pickedFile.path));
              NavigationService.goBack();
            }
          },
          text: LocaleKeys.camera.tr(),
          iconData: Icons.camera_alt,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
        IconsOutlineButton(
          onPressed: () async {
            XFile? pickedFile = await (ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 33));
            if (pickedFile != null) {
              callback(File(pickedFile.path));
              NavigationService.goBack();
            }
          },
          text: LocaleKeys.gallery.tr(),
          iconData: Icons.photo_library,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
      ],
    );
  }

  select<T>({required List<T> list, required Function(T) callback}) async {
    Dialogs.bottomMaterialDialog(
        msg: LocaleKeys.selectImageType.tr(),
        color: Colors.white,
        context: NavigationService.navigationKey.currentContext!,
        customViewPosition: CustomViewPosition.AFTER_ACTION,
        customView: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppTextTile(
                leading: Icon(Icons.circle, size: 14, color: AppColorLight().kPrimaryColor),
                title: CustomText(list[index].toString()),
                onTap: () {
                  callback(list[index]);
                  NavigationService.goBack();
                },
              ),
            );
            // return ListTile(
            //   title: Text(list[index].toString()),
            //   onTap: () {
            //     callback(list[index]);
            //     NavigationService.goBack();

            //   },
            // );
          },
        ));
  }
}
