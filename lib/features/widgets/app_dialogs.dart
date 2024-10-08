import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/base/response_model.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/domain/usecase/order/order_rate_usecase.dart';
import 'package:weltweit/features/logic/order/order_cubit.dart';
import 'package:weltweit/features/screens/auth/otp/otp_cubit.dart';
import 'package:weltweit/features/screens/layout/layout_cubit.dart';
import 'package:weltweit/features/screens/provider_subscribe/payment_webview.dart';
import 'package:weltweit/features/screens/provider_subscribe/subscribe_page.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/custom_button.dart';
import 'package:weltweit/presentation/component/inputs/base_form.dart';

import '../../core/routing/routes.dart';
import '../logic/service/services_cubit.dart';

class AppDialogs {
  Future<File?> pickImage(BuildContext context) async {
    File? file;
    await Dialogs.materialDialog(
        msg: LocaleKeys.selectImageSource.tr(),
        color: Colors.white,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () async {
              XFile? pickedFile = await (ImagePicker()
                  .pickImage(source: ImageSource.camera, imageQuality: 33));
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
    String? buttonTitle1,
    String? buttonTitle2,
    required String message,
  }) async {
    bool? result;
    await Dialogs.materialDialog(
      title: title ?? LocaleKeys.notification.tr(),
      msgAlign: TextAlign.center,
      msg: message,
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            result = true;
            NavigationService.goBack();
          },
          text:buttonTitle1?? LocaleKeys.yes.tr(),
          iconData: Icons.check,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            result = false;
            NavigationService.goBack();
          },
          text: buttonTitle2?? LocaleKeys.no.tr(),
          iconData: Icons.close,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
      ],
    );
    return result ?? false;
  }

  void rateOrderDialog(BuildContext context, OrderModel orderModel,String type) async {
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
                    print(rate);
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
                        clientId: orderModel.client!.id,
                        fromType:type,
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
                        Navigator.pop(context);
                        // if (context.mounted) {
                        //   AppSnackbar.show(
                        //     context: context,
                        //     message: LocaleKeys.selectRate.tr(),
                        //     type: SnackbarType.error,
                        //   );
                        // }
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

  // void activateMailDialog({
  //   required BuildContext context,
  //   required String message,
  //   required bool typeIsProvider,
  // }) async {
  //   TextEditingController controller = TextEditingController();
  //   Dialogs.materialDialog(
  //     title: LocaleKeys.notification.tr(),
  //     msg: message,
  //     color: Colors.white,
  //     context: context,
  //     actions: [
  //       StatefulBuilder(
  //         builder: (context, setState) {
  //           return Column(
  //             children: [
  //               CustomTextField(
  //                 hint: LocaleKeys.email.tr(),
  //                 controller: controller,
  //               ),
  //               SizedBox(height: 10),
  //               Row(
  //                 children: [
  //                   SizedBox(width: 4),
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: CustomText(LocaleKeys.cancel.tr()),
  //                   ),
  //                   Spacer(),
  //                   TextButton(
  //                       onPressed: () {
  //                         if (controller.text.isEmpty) {
  //                           AppSnackbar.show(
  //                             context: context,
  //                             message: LocaleKeys.msgEmailRequired.tr(),
  //                             type: SnackbarType.error,
  //                           );
  //                         } else {
  //                           NavigationService.push(RoutesServices.servicesOtpScreen, arguments: {
  //                             'email': controller.text,
  //                             'code': '20',
  //                             'checkOTPType':  CheckOTPType.register,
  //                             'typeIsProvider': typeIsProvider,
  //                           });
  //                         }
  //                       },
  //                       child: CustomText(LocaleKeys.activate.tr())),
  //                   SizedBox(width: 4),
  //                 ],
  //               )
  //             ],
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  void forgetPassword({
    required BuildContext context,
    required String title,
    required String message,
    required bool typeIsProvider,
  }) async {
    bool loading = false;
    TextEditingController controller = TextEditingController();
    Dialogs.materialDialog(
      title: title,
      msg: message,
      color: Colors.white,
      context: context,
      actions: [
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                CustomTextField(hint: LocaleKeys.email.tr(), controller: controller),
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
                    if (loading) CircularProgressIndicator(),
                    if (!loading)
                      TextButton(
                          onPressed: () async {
                            loading = true;
                            setState(() {});
                            if (controller.text.isEmpty) {
                              AppSnackbar.show(
                                context: context,
                                message: LocaleKeys.msgEmailRequired.tr(),
                                type: SnackbarType.error,
                              );
                            } else {
                              try {
                                await sendOtp(context, controller.text, typeIsProvider);

                                loading = false;
                                setState(() {});
                                Navigator.pop(context);
                                NavigationService.push(RoutesServices.servicesOtpScreen, arguments: {
                                  'email': controller.text,
                                  'code': '20',
                                  'checkOTPType': CheckOTPType.register,
                                  'typeIsProvider': typeIsProvider,
                                });
                              } catch (e) {
                                kEcho(e.toString());
                                loading = false;
                                setState(() {});
                                AppSnackbar.show(context: context, message: e.toString(), type: SnackbarType.error);
                              }
                            }
                          },
                          child: CustomText(LocaleKeys.send.tr())),
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

  Future<bool> sendOtp(BuildContext context, String email, bool typeIsProvider) async {
    ResponseModel responseModel = await BlocProvider.of<OtpCubit>(context, listen: false).reSendCodeNoState(email: email, typeIsProvider: typeIsProvider);
    if (responseModel.message != null && responseModel.message!.isNotEmpty) {
      if (responseModel.isSuccess) {
        return true;
      } else {
        return Future.error(responseModel.message ?? LocaleKeys.error.tr());
      }
    } else {
      return Future.error(LocaleKeys.somethingWentWrong.tr());
    }
  }

  Future<void> languageDialog(BuildContext context) async {
    Locale locale = context.locale;
    await Dialogs.materialDialog(
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
            NavigationService.navigationKey.currentContext!.read<ServicesCubit>().getHomeServices();

            NavigationService.goBack();
            // NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesSplashScreen);
          },
          text: "English",
          iconData: locale.languageCode.contains('en')? Icons.circle : Icons.circle_outlined,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
        IconsOutlineButton(
          onPressed: () {
            context.setLocale(Locale('ar'));
            AppPrefs prefs = getIt<AppPrefs>();
            prefs.save(PrefKeys.lang, "ar");
            NavigationService.navigationKey.currentContext!.read<ServicesCubit>().getHomeServices();

            NavigationService.goBack();

          },
          text: "عربي",
          iconData: locale.languageCode.contains('ar')? Icons.circle : Icons.circle_outlined,
          textStyle: TextStyle(color: primaryColor),
          iconColor: primaryColor,
        ),
      ],
    );
  }

  void showKioskPaymentDialog(BuildContext context, String s) {
    Dialogs.materialDialog(title: "${LocaleKeys.payment.tr()} Kiosk", msg: "Kiosk reference number ", color: Colors.white, context: context, actions: [
      CustomText(s),
      IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: s));
            AppSnackbar.show(
              context: context,
              message: "Copied successfully",
              type: SnackbarType.success,
            );
          },
          icon: Icon(Icons.copy)),
    ]);
  }

  Future<String> showCreditMethodsDialog(
    context, {
    required String price,
    required String period,
    required String currency,
    required String profileWallet,
    // required String url,
  }) async {
    bool isSaudi =
        getIt<AppPrefs>().get(PrefKeys.countryId, defaultValue: false) == 2;

    print(isSaudi);
    String selectedMethodToReturn = "";
    await showDialog(
      context: context,
      builder: (context) {
        SubscriptionMethods selectedMethod = SubscriptionMethods.request;
        CreditMethodsEgypt selectedCreditMethodEgypt = CreditMethodsEgypt.visa;
        CreditMethodsSaudi selectedCreditMethodSaudi = CreditMethodsSaudi.visa;

        return AlertDialog(
          title: CustomText(LocaleKeys.subscribeNow2.tr()),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CustomText('${LocaleKeys.price.tr()}:$price $currency').footer().expanded(),
                    CustomText('${LocaleKeys.period.tr()}:$period').footer().expanded(),
                  ],
                ),
                Divider(),
                //            ElevatedButton(
                //                   onPressed: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentWebview( url: url))),
                //                   style: ElevatedButton.styleFrom(
                //                     backgroundColor: Colors.blue,
                //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                //                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //                   ),
                //                   child: CustomText(LocaleKeys.subscribeNow.tr(), color: Colors.white,).headerExtra(),
                //                 ),
                if (isSaudi)
                  Column(
                    children: [
                      //radio select Wallet , credit card , cash

                      ...SubscriptionMethods.values.map((e) {
                        String title = e.name;
                        if (e.name.contains("wallet")) {
                          title = "wallet ($profileWallet)";
                        }
                        bool isEnable = true;
                        // if (e.name.contains('credit')) isEnable = false;
                        if (isEnable) {
                          if (e.name.contains("wallet")) {
                            double? wallet = double.tryParse(profileWallet) ?? 0;
                            isEnable = wallet >= double.parse(price.toString());
                          }
                        }
                        return RadioListTile(
                          value: e,
                          groupValue: selectedMethod,
                          onChanged: (value) {
                            if (isEnable) {
                              selectedMethod = value!;
                              setState(() {});
                            }
                          },
                          title: CustomText(
                            convertToName(title),
                            color: !isEnable ? Colors.grey : Colors.black,
                          ).start(),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        );
                      }).toList(),

                      if (selectedMethod == SubscriptionMethods.credit)
                        Container(
                          decoration: BoxDecoration().radius(radius: 12).customColor(Colors.white),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              ...CreditMethodsSaudi.values.map((e) {
                                String title = e.name;
                                return RadioListTile(
                                    value: e,
                                    groupValue: selectedCreditMethodSaudi,
                                    onChanged: (value) {
                                      selectedCreditMethodSaudi = value!;
                                      setState(() {});
                                    },
                                    title: CustomText(convertToName(title), color: Colors.black).start(),
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    visualDensity: VisualDensity(
                                        horizontal: -4, vertical: -4));
                              }).toList(),
                            ],
                          ),
                        ),

                      SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: () async {
                          NavigationService.goBack();
                          if (selectedMethod == SubscriptionMethods.credit) {
                            selectedMethodToReturn = selectedCreditMethodSaudi.name;
                          } else {
                            selectedMethodToReturn = selectedMethod.name;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: CustomText(
                          LocaleKeys.subscribeNow2.tr(),
                          color: Colors.white,
                        ).headerExtra(),
                      ),
                    ],
                  )




                else
                  Column(
                    children: [
                      //radio select Wallet , credit card , cash

                      ...SubscriptionMethods.values.map((e) {
                        String title = e.name;
                        if (e.name.contains("wallet")) {
                          title = "wallet ($profileWallet)";
                        }
                        bool isEnable = true;
                        // if (e.name.contains('credit')) isEnable = false;
                        if (isEnable) {
                          if (e.name.contains("wallet")) {
                            double? wallet = double.tryParse(profileWallet) ?? 0;
                            isEnable = wallet >= double.parse(price.toString());
                          }
                        }
                        return RadioListTile(
                          value: e,
                          groupValue: selectedMethod,
                          onChanged: (value) {
                            if (isEnable) {
                              selectedMethod = value!;
                              setState(() {});
                            }
                          },
                          title: CustomText(
                            convertToName(title),
                            color: !isEnable ? Colors.grey : Colors.black,
                          ).start(),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        );
                      }).toList(),

                      if (selectedMethod == SubscriptionMethods.credit)
                        Container(
                          decoration: BoxDecoration().radius(radius: 12).customColor(Colors.white),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              ...CreditMethodsEgypt.values.map((e) {
                                String title = e.name;
                                return RadioListTile(
                                    value: e,
                                    groupValue: selectedCreditMethodEgypt,
                                    onChanged: (value) {
                                      selectedCreditMethodEgypt = value!;
                                      setState(() {});
                                    },
                                    title: CustomText(convertToName(title), color: Colors.black).start(),
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    visualDensity: VisualDensity(
                                        horizontal: -4, vertical: -4));
                              }).toList(),
                            ],
                          ),
                        ),

                      SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: () async {
                          NavigationService.goBack();
                          if (selectedMethod == SubscriptionMethods.credit) {
                            selectedMethodToReturn = selectedCreditMethodEgypt.name;
                          } else {
                            selectedMethodToReturn = selectedMethod.name;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: CustomText(
                          LocaleKeys.subscribeNow2.tr(),
                          color: Colors.white,
                        ).headerExtra(),
                      ),
                    ],
                  ),
              ],
            );
          }),
        );
      },
    );
    return selectedMethodToReturn;
  }

  //
}
