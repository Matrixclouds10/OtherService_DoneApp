import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/domain/usecase/order/order_rate_usecase.dart';
import 'package:weltweit/features/logic/order/order_cubit.dart';
import 'package:weltweit/features/screens/layout/layout_cubit.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/custom_button.dart';
import 'package:weltweit/presentation/component/inputs/base_form.dart';

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

  selectWidget({required BuildContext context, required List<Widget> list, required String message}) async {
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
            if (context.mounted) context.read<LayoutCubit>().setCurrentIndex(context: context, i: 0);
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

  void rateOrderDialog(BuildContext context, OrderModel orderModel) async {
    double rate = 0;
    bool loading = false;
    TextEditingController controller = TextEditingController();
    Dialogs.materialDialog(
      title: LocaleKeys.rate.tr(),
      msg: LocaleKeys.rateOrder.tr(),
      color: Colors.white,
      context: context,
      actions: [
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rate = rating;
                    });
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hint: LocaleKeys.comment.tr(),
                  controller: controller,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onTap: () async {
                    if (rate == 0) {
                      AppSnackbar.show(
                        context: context,
                        message: LocaleKeys.selectRate.tr(),
                        type: SnackbarType.error,
                      );
                    } else {
                      OrderRateParams params = OrderRateParams(
                        comment: controller.text,
                        rate: rate.ceil(),
                        orderId: orderModel.id,
                        providerId: orderModel.provider!.id!,
                      );
                      loading = true;
                      setState(() {});
                      bool status = await context.read<OrderCubit>().rateOrder(params: params);
                      loading = false;
                      setState(() {});
                      if (status) {
                        NavigationService.goBack();
                        if (context.mounted) {
                          AppSnackbar.show(
                            context: context,
                            message: LocaleKeys.rateSuccess.tr(),
                            type: SnackbarType.success,
                          );
                        }
                      } else {
                        if (context.mounted) {
                          AppSnackbar.show(
                            context: context,
                            message: LocaleKeys.selectRate.tr(),
                            type: SnackbarType.error,
                          );
                        }
                      }
                    }
                  },
                  loading: loading,
                  title: LocaleKeys.rate.tr(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void activateMailDialog({
    required BuildContext context,
    required String message,
    required bool typeIsProvider,
  }) async {
    TextEditingController controller = TextEditingController();
    Dialogs.materialDialog(
      title: LocaleKeys.notification.tr(),
      msg: message,
      color: Colors.white,
      context: context,
      actions: [
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                CustomTextField(
                  hint: LocaleKeys.email.tr(),
                  controller: controller,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: CustomText(LocaleKeys.cancel.tr()),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          if (controller.text.isEmpty) {
                            AppSnackbar.show(
                              context: context,
                              message: LocaleKeys.msgEmailRequired.tr(),
                              type: SnackbarType.error,
                            );
                          } else {
                            NavigationService.push(RoutesServices.servicesOtpScreen, arguments: {
                              'email': controller.text,
                              'code': '20',
                              'checkOTPType': CheckOTPType.register,
                              'typeIsProvider': typeIsProvider,
                            });
                          }
                        },
                        child: CustomText(LocaleKeys.activate.tr())),
                    SizedBox(width: 4),
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }

  void languageDialog(BuildContext context) {
    Dialogs.materialDialog(
      title: LocaleKeys.language.tr(),
      msg: LocaleKeys.selectLanguage.tr(),
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            context.setLocale(Locale('en'));
            AppPrefs prefs = getIt<AppPrefs>();
            prefs.save(PrefKeys.lang, "en");

            NavigationService.goBack();
          },
          text: "English",
          iconData: Icons.circle_outlined,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            context.setLocale(Locale('ar'));
            AppPrefs prefs = getIt<AppPrefs>();
            prefs.save(PrefKeys.lang, "ar");
            NavigationService.goBack();
          },
          text: "عربي",
          iconData: Icons.circle_outlined,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
      ],
    );
  }

  //
}
