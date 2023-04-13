import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class AppDialogs {
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
        textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
        iconColor: AppColorLight().kPrimaryColor,
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
        textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
        iconColor: AppColorLight().kPrimaryColor,
      ),
    ]);
    log('file', 'return null');
    return file;
  }

  Future<bool> confirmDelete(BuildContext context) async {
    bool? result;
    await Dialogs.materialDialog(
      msg: LocaleKeys.confirmDelete.tr(),
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            result = true;
            NavigationService.goBack();
          },
          text: LocaleKeys.yes.tr(),
          iconData: Icons.check,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            result = false;
            NavigationService.goBack();
          },
          text: LocaleKeys.no.tr(),
          iconData: Icons.close,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
      ],
    );
    return result ?? false;
  }

  Future<bool> confirm(
    BuildContext context, {
    String? title,
    required String message,
  }) async {
    bool? result;
    await Dialogs.materialDialog(
      title: title ?? LocaleKeys.notification.tr(),
      msg: message,
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            result = true;
            NavigationService.goBack();
          },
          text: LocaleKeys.yes.tr(),
          iconData: Icons.check,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            result = false;
            NavigationService.goBack();
          },
          text: LocaleKeys.no.tr(),
          iconData: Icons.close,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
      ],
    );
    return result ?? false;
  }

  select<T>({required BuildContext context, required List<T> list}) async {
    T? selected;
    await Dialogs.materialDialog(
        msg: LocaleKeys.selectImageType.tr(),
        color: Colors.white,
        context: NavigationService.navigationKey.currentContext!,
        customViewPosition: CustomViewPosition.AFTER_ACTION,
        customView: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          padding: EdgeInsets.only(bottom: 12),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
              child: AppTextTile(
                leading: Icon(Icons.circle, size: 14, color: AppColorLight().kPrimaryColor),
                title: CustomText(list[index].toString()),
                onTap: () {
                  selected = list[index];
                  NavigationService.goBack();
                },
              ),
            );
          },
        ));
    log('file', 'return null');
    return selected;
  }

  selectWidget({required BuildContext context, required List<Widget> list,required String message}) async {
    Widget? selected;
    await Dialogs.materialDialog(
        msg: message,
        color: Colors.white,
        context: NavigationService.navigationKey.currentContext!,
        customViewPosition: CustomViewPosition.AFTER_ACTION,
        customView: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: list[index],
            );
          },
        ));
    log('file', 'return null');
    return selected;
  }

  Future<bool?> showDeleteAccountDialog(BuildContext context) async {
    bool? result;
    await Dialogs.materialDialog(
      msg: LocaleKeys.confirmDeleteAccount.tr(),
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            result = true;
            NavigationService.goBack();
          },
          text: LocaleKeys.yes.tr(),
          iconData: Icons.check,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            NavigationService.goBack();
          },
          text: LocaleKeys.no.tr(),
          iconData: Icons.close,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
      ],
    );
    return result;
  }

  void logoutDialog(BuildContext context) {
    Dialogs.materialDialog(
      msg: LocaleKeys.confirmLogout.tr(),
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            NavigationService.goBack();
          },
          text: LocaleKeys.no.tr(),
          iconData: Icons.close,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            AppPrefs prefs = getIt<AppPrefs>();
            prefs.clear();
            prefs.deleteSecuredData();
            NavigationService.goBack();
            NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesSplashScreen);
          },
          text: LocaleKeys.yes.tr(),
          iconData: Icons.check,
          textStyle: TextStyle(color: AppColorLight().kPrimaryColor),
          iconColor: AppColorLight().kPrimaryColor,
        ),
      ],
    );
  }

  void showImageDialog(BuildContext context, String s) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: deviceWidth - 20,
              width: deviceHeight - 50,
              child: PhotoView(
                imageProvider: NetworkImage(s),
              ),
            ),
          );
        });
  }


  Future<bool> question(
    BuildContext context, {
    String? title,
    required String message,
  }) async {
    bool? result;
    await Dialogs.materialDialog(
      title: title ?? LocaleKeys.notification.tr(),
      msg: message,
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            result = true;
            NavigationService.goBack();
          },
          text: LocaleKeys.yes.tr(),
          iconData: Icons.check,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            result = false;
            NavigationService.goBack();
          },
          text: LocaleKeys.no.tr(),
          iconData: Icons.close,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
      ],
    );
    return result ?? false;
  }

}