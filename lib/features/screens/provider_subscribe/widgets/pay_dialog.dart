// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../core/routing/navigation_services.dart';
// import '../../../../core/utils/echo.dart';
// import '../../../../data/datasource/remote/exception/error_widget.dart';
// import '../../../../generated/locale_keys.g.dart';
// import '../../../core/routing/routes_provider.dart';
// import '../../../core/widgets/custom_text.dart';
// import '../../../data/models/subscription/subscription_model.dart';
// import '../../../data/models/subscription/update_subscribtion_response.dart';
// import '../../../logic/provider_subscription/subscription_cubit.dart';
// import '../../../widgets/app_dialogs.dart';
// import '../../../widgets/app_snackbar.dart';
// import '../subscribe_page.dart';
//
// void actionSubscribe(BuildContext context,SubscriptionModel e, String selectedMethod) async {
//   String desc = "";
//   desc += "${LocaleKeys.price.tr()}: ${e.price} ${getCountryCurrency(context)}\n";
//   desc += "${LocaleKeys.period.tr()}: ${e.period}\n";
//   desc += "${LocaleKeys.paymentMethod.tr()}: ${convertToName(selectedMethod)} \n";
//
//   //show dialog to confirm
//   String message = "";
//   message += "${LocaleKeys.confirmSubscribtion.tr()}\n";
//   message += desc;
//   bool status = await AppDialogs().question(context, message: message);
//   if (!status) return;
//
//   bool paymentMethodOnWeb = false;
//   for (var item in CreditMethods.values) {
//     if (selectedMethod == item.name) {
//       paymentMethodOnWeb = true;
//       break;
//     }
//   }
//   if (paymentMethodOnWeb) {
//     actionPerformSubscribeWebPayment(e, selectedMethod);
//   } else {
//     actionPerformSubscribe(subscriptionModel: e, selectedMethod: selectedMethod, desc: desc);
//   }
// }
// void actionPerformSubscribeWebPayment(SubscriptionModel subscriptionModel, String selectedMethod) async {
//   try {
//     UpdateSubscribtionResponse updateSubscribtionResponse = await context
//         .read<SubscriptionCubit>()
//         .subscribe(subscriptionModel.id, selectedMethod);
//
//     kEcho(
//         "paymentUrl: ${updateSubscribtionResponse.paymentData?.redirectUrl}");
//
//     if (updateSubscribtionResponse.paymentData != null) {
//       if (updateSubscribtionResponse.paymentData?.redirectUrl != null) {
//         NavigationService.push(RoutesProvider.paymentWebview, arguments: {
//           'id': subscriptionModel.id,
//           'url': updateSubscribtionResponse.paymentData?.redirectUrl,
//         });
//       } else if (updateSubscribtionResponse.paymentData?.kioskBillReference !=
//           null) {
//         if (mounted) {
//           AppDialogs().showKioskPaymentDialog(
//             context,
//             updateSubscribtionResponse.paymentData?.kioskBillReference ?? "",
//           );
//         }
//       }
//     } else {
//       AppSnackbar.show(
//         context: NavigationService.navigationKey.currentContext!,
//         message: LocaleKeys.somethingWentWrong.tr(),
//       );
//       setState(() {});
//     }
//   } catch (e) {
//     String errorMessge = "";
//     if (e is ErrorModel) {
//       errorMessge = e.errorMessage ?? "";
//     }
//     AppSnackbar.show(
//       context: NavigationService.navigationKey.currentContext!,
//       message: '${LocaleKeys.somethingWentWrong.tr()} \n $errorMessge',
//     );
//
//     setState(() {});
//   }
// }
//
// void actionPerformSubscribe({
//   required SubscriptionModel subscriptionModel,
//   required String selectedMethod,
//   required String desc,
// }) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: CustomText(LocaleKeys.confirmSubscribtion.tr()),
//         content: StatefulBuilder(builder: (context, setState) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CustomText(desc),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//                       try {
//                         UpdateSubscribtionResponse response = await context.read<SubscriptionCubit>().subscribe(subscriptionModel.id, selectedMethod);
//                         AppSnackbar.show(context: NavigationService.navigationKey.currentContext!, message: LocaleKeys.somethingWentWrong.tr());
//
//                         setState(() {});
//                       } catch (e) {
//                         String errorMessage = "";
//                         if (e is ErrorModel) {
//                           errorMessage = e.errorMessage ?? "";
//                         }
//                         AppSnackbar.show(
//                             context: NavigationService
//                                 .navigationKey.currentContext!,
//                             message: errorMessage);
//                         setState(() {});
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     ),
//                     child: CustomText(
//                       LocaleKeys.confirm.tr(),
//                       color: Colors.white,
//                     ).headerExtra(),
//                   ),
//                   Spacer(),
//                   ElevatedButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     ),
//                     child: CustomText(
//                       LocaleKeys.cancel.tr(),
//                       color: Colors.white,
//                     ).headerExtra(),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         }),
//       );
//     },
//   );
// }