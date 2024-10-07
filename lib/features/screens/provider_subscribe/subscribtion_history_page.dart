import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/utils/date/date_converter.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/subscription/subscription_history_model.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/data/models/subscription/update_subscribtion_response.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_subscription/subscription_cubit.dart';
import 'package:weltweit/features/screens/provider_subscribe/subscribe_page.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/empty_widget.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

import '../../../base_injection.dart';
import '../../../core/services/local/cache_consumer.dart';
import '../../../core/services/local/storage_keys.dart';

class SubscribtionHistoryPage extends StatefulWidget {
  const SubscribtionHistoryPage({super.key});

  @override
  State<SubscribtionHistoryPage> createState() => _SubscribtionHistoryPageState();
}

class _SubscribtionHistoryPageState extends State<SubscribtionHistoryPage> {
  bool? isSaudi;
  AppPrefs prefs = getIt<AppPrefs>();
  late SubscriptionCubit subscriptionCubit;

  @override
  void initState() {
    super.initState();
    subscriptionCubit = context.read<SubscriptionCubit>();

    // SubscriptionCubit subscriptionCubit = context.read<SubscriptionCubit>();
    subscriptionCubit.getSubscribtionsHistory();
    isSaudi = prefs.get(PrefKeys.countryId, defaultValue: false) == 2;
    print('is saudi $isSaudi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.subscribtionHistory.tr()).header(),
        isCenterTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBk2),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state.subscribtionHistoryState == BaseState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.subscribtionHistoryState == BaseState.error) {
              return ErrorLayout(
                  errorModel: ErrorModel(
                      errorMessage: LocaleKeys.somethingWentWrong.tr()),
                  onRetry: () {
                    context.read<SubscriptionCubit>().getSubscribtionsHistory();
                  });
            }
            if (state.data.isEmpty) {
              return const EmptyView(message: "No Subscribtions");
            }
            return SingleChildScrollView(
              child: ListAnimator(
                children: [
                  SizedBox(height: 24),
                  if (state.subscribeData2!=null && state.subscribeData2 != "") Container(
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
                    child:
                    CustomText(state.subscribeData2 ?? "", color: primaryColor).headerExtra().start(),

                  ),
                  ...state.subscribtionHistoryData
                      .map((e) => _buildItem(e))
                      .toList(),
                  SizedBox(height: 64),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _buildItem(SubscriptionHistoryModel e) {
    log('ssss', e.paymentStatus.toString());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
      child: Column(
        children: [
          ListTile(
            title: Text(e.paymentMethod ?? ""),
            leading: Icon(Icons.credit_card_outlined, color: Colors.grey),
            visualDensity: VisualDensity.compact,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            title: Text(e.status ?? ""),
            leading: Icon(Icons.check_circle_outline, color: Colors.grey),
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
          ),
          if (e.startsAt != null && e.endsAt != null)
            ListTile(
              title: Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomText(
                    "${DateConverter.estimatedDate(e.startsAt!)} - ${DateConverter.estimatedDate(e.endsAt!)}",
                    align: TextAlign.start,
                  )),
              leading: Icon(Icons.date_range_outlined, color: Colors.grey),
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
            ),
          Divider(),
          if (e.subscription != null)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(e.subscription!.name ?? "", color: primaryColor).headerExtra().start(),
                    CustomText("${LocaleKeys.period.tr()}: ${e.subscription!.period}", color: Colors.grey[500]!, pv: 0).footer().start(),
                  ],
                ).expanded(),
                CustomText("${e.subscription!.price.toString()} ${getCountryCurrency()}", color: AppColorLight().kAccentColor).headerExtra(),
              ],
            ),
          if (e.paymentStatus!.toLowerCase() == 'pending') ...[
          // if (e.paymentStatus!.toLowerCase() == 'pending') ...[
            SizedBox(height: 12),
            BlocBuilder<SubscriptionCubit, SubscriptionState>(
              builder: (context, state) {
                return CustomButton(
                  onTap: () async {
                    if (state.rePaySubscribeState == BaseState.loading||e.id == null) return;

                    String paymentMethod = await context.read<SubscriptionCubit>().actionShowSubscriptionMethods(context: context, subscriptionModel: e.subscription!);
                    bool status = await _showStatusDialog(e.subscription,paymentMethod);
                    if(!status)return;
                    UpdateSubscribtionResponse? response = await context.read<SubscriptionCubit>().reSubscribe(e.id!, paymentMethod);

                    if (paymentMethod.isEmpty){
                      // NavigationService.push(RoutesProvider.paymentWebview, arguments: {'id': e.id, 'url': updateSubscribtionResponse?.paymentData?.redirectUrl});
                    }else{
                    }

                    if (response?.paymentData?.redirectUrl != null) {
                      NavigationService.push(RoutesProvider.paymentWebview, arguments: {'id': e.id, 'url': response?.paymentData?.redirectUrl});
                    } else if (response?.paymentData?.kioskBillReference != null && mounted) {
                      AppDialogs().showKioskPaymentDialog(context, response?.paymentData?.kioskBillReference ?? "");
                    }
                    return;

                    try {
                      //show dialog to confirm
                      String message = "";
                      message += "${LocaleKeys.confirmSubscribtion.tr()}\n";
                      message += "${LocaleKeys.price.tr()}: ${e.subscription!.price} ${getCountryCurrency()}\n";
                      message += "${LocaleKeys.period.tr()}: ${e.subscription!.period}\n";
                      message += "${LocaleKeys.paymentMethod.tr()}: ${convertToName('')}\n";
                      bool status = await AppDialogs().question(context, message: message);
                      if (!status) return;

                      UpdateSubscribtionResponse? updateSubscribtionResponse = await context.read<SubscriptionCubit>().reSubscribe(e.id!, 'visa');

                      print('zzzz ${e.id}');
                      if (updateSubscribtionResponse?.paymentData != null) {
                        ///start get payment methods
                        // String paymentMethod = await context.read<SubscriptionCubit>().actionShowSubscriptionMethods(context: context, url: '${updateSubscribtionResponse?.paymentData?.redirectUrl}', subscriptionModel: e.subscription!);

                        // else {
                        //   // AppDialogs().showKioskPaymentDialog(context, updateSubscribtionResponse?.paymentData?.kioskBillReference ?? "");
                        //
                        //   // actionSubscribe(context,e.subscription!, paymentMethod);
                        // }
                        ///end
                        // if (updateSubscribtionResponse?.paymentData?.redirectUrl != null) {
                        //   NavigationService.push(RoutesProvider.paymentWebview, arguments: {'id': e.id, 'url': updateSubscribtionResponse?.paymentData?.redirectUrl});
                        // } else if (updateSubscribtionResponse?.paymentData?.kioskBillReference != null && mounted) {
                        //   AppDialogs().showKioskPaymentDialog(context, updateSubscribtionResponse?.paymentData?.kioskBillReference ?? "");
                        // }
                      } else {
                        AppSnackbar.show(context: NavigationService.navigationKey.currentContext!, message: LocaleKeys.somethingWentWrong.tr(),);
                      }
                    } catch (e) {
                      String errorMessge = "";
                      if (e is ErrorModel) {
                        errorMessge = e.errorMessage ?? "";
                      }
                      AppSnackbar.show(
                        context: NavigationService.navigationKey.currentContext!,
                        message: errorMessge,
                      );
                      setState(() {});
                    }
                  },
                  loading: state.rePaySubscribeState == BaseState.loading,
                  child: CustomText(LocaleKeys.payNow.tr(), color: Colors.white),
                );
              },
            ),
          ],
          SizedBox(height: 12),
        ],
      ),
    );
  }

  // Future<String> actionShowSubscriptionMethods(SubscriptionModel subscriptionModel) async {
  //   String selectedMethodToReturn = "";
  //   ProfileProviderCubit profileProviderCubit = context.read<ProfileProviderCubit>();
  //   SubscriptionMethods selectedMethod = SubscriptionMethods.request;
  //   CreditMethods selectedCreditMethod = CreditMethods.visa;
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: CustomText(LocaleKeys.subscribeNow.tr()),
  //         content: StatefulBuilder(builder: (context, setState) {
  //           return Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 children: [
  //                   CustomText('${LocaleKeys.price.tr()}:${subscriptionModel.price} ${getCountryCurrency()}').footer().expanded(),
  //                   CustomText('${LocaleKeys.period.tr()}:${subscriptionModel.period}').footer().expanded(),
  //                 ],
  //               ),
  //               Divider(),
  //               Column(
  //                 children: [
  //                   //radio select Wallet , credit card , cash
  //                   ...SubscriptionMethods.values.map((e) {
  //                     String title = e.name;
  //                     if (e.name.contains("wallet")) title = "wallet (${profileProviderCubit.state.data?.wallet ?? ''})";
  //                     bool isEnable = true;
  //                     // if (e.name.contains('credit')) isEnable = false;
  //                     if (isEnable) {
  //                       if (e.name.contains("wallet")) {
  //                         double? wallet = double.tryParse(profileProviderCubit.state.data?.wallet.toString() ?? "") ?? 0;
  //                         isEnable = wallet >= double.parse(subscriptionModel.price.toString());
  //                       }
  //                     }
  //                     return RadioListTile(
  //                       value: e,
  //                       groupValue: selectedMethod,
  //                       onChanged: (value) {
  //                         if (isEnable) {
  //                           selectedMethod = value!;
  //                           setState(() {});
  //                         }
  //                       },
  //                       title: CustomText(
  //                         convertToName(title),
  //                         color: !isEnable ? Colors.grey : Colors.black,
  //                       ).start(),
  //                       contentPadding: EdgeInsets.zero,
  //                       dense: true,
  //                       visualDensity: VisualDensity(horizontal: -4, vertical: -4),
  //                     );
  //                   }).toList(),
  //
  //                   if (selectedMethod == SubscriptionMethods.credit)
  //                     Container(
  //                       decoration: BoxDecoration().radius(radius: 12).customColor(Colors.white),
  //                       padding: const EdgeInsets.symmetric(horizontal: 12),
  //                       child: Column(
  //                         children: [
  //                           ...CreditMethods.values.map((e) {
  //                             String title = e.name;
  //                             return RadioListTile(
  //                                 value: e,
  //                                 groupValue: selectedCreditMethod,
  //                                 onChanged: (value) {
  //                                   selectedCreditMethod = value!;
  //                                   setState(() {});
  //                                 },
  //                                 title: CustomText(title.replaceAll('_', ' '), color: Colors.black).start(),
  //                                 contentPadding: EdgeInsets.zero,
  //                                 dense: true,
  //                                 visualDensity: VisualDensity(horizontal: -4, vertical: -4));
  //                           }).toList(),
  //                         ],
  //                       ),
  //                     ),
  //
  //                   SizedBox(height: 12),
  //
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       NavigationService.goBack();
  //                       if (selectedMethod == SubscriptionMethods.credit) {
  //                         selectedMethodToReturn = selectedCreditMethod.name;
  //                       } else {
  //                         selectedMethodToReturn = selectedMethod.name;
  //                       }
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.blue,
  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                     ),
  //                     child: CustomText(
  //                       LocaleKeys.subscribeNow.tr(),
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
  //   return selectedMethodToReturn;
  // }
  _showStatusDialog( SubscriptionModel? subscription, String paymentMethod)async{
    String message = "";
    message += "${LocaleKeys.confirmSubscribtion.tr()}\n";
    message += "${LocaleKeys.price.tr()}: ${subscription!.price} ${getCountryCurrency()}\n";
    message += "${LocaleKeys.period.tr()}: ${subscription.period}\n";
    message += "${LocaleKeys.paymentMethod.tr()}: ${convertToName(paymentMethod)}\n";
    bool status = await AppDialogs().question(context, message: message);
    return status ;

  }
  getCountryCurrency() {
    ProfileProviderCubit profileProviderCubit = context.read<ProfileProviderCubit>();
    if (profileProviderCubit.state.data?.countryModel?.title == 'مصر') {
      return 'جنيه';
    } else if (profileProviderCubit.state.data?.countryModel?.title == 'السعودية') {
      return 'ريال';
    }
    return '';
  }
}
