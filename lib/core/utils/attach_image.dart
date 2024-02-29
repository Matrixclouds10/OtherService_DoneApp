import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

Future<File?> onPickImagesPressed(BuildContext context) async {
  return pickImage(context);
}

Future<File?> pickImage(BuildContext context) async {
  File? file;
  await Dialogs.materialDialog(msg: LocaleKeys.selectImageSource.tr(), color: Colors.white, context: context, actions: [
    IconsOutlineButton(
      onPressed: () async {
        XFile? pickedFile = await (ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 33));
        if (pickedFile != null) {
          file = File(pickedFile.path);
          NavigationService.goBack();
        }
      },
      text: LocaleKeys.camera.tr(),
      iconData: Icons.camera_alt,
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
      iconColor: Theme.of(context).primaryColor,
    ),
    IconsOutlineButton(
      onPressed: () async {
        XFile? pickedFile = await (ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 33));
        if (pickedFile != null) {
          file = File(pickedFile.path);
          NavigationService.goBack();
        }
      },
      text: LocaleKeys.gallery.tr(),
      iconData: Icons.photo_library,
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
      iconColor: Theme.of(context).primaryColor,
    ),
  ]);
  return file;
}
