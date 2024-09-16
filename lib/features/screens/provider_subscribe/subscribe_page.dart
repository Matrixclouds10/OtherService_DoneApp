import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/data/models/subscription/update_subscribtion_response.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_subscription/subscription_cubit.dart';
import 'package:weltweit/features/screens/provider_subscribe/subscribtion_history_page.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/empty_widget.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

import '../../../base_injection.dart';
import '../../../core/services/local/cache_consumer.dart';
import '../../../core/services/local/storage_keys.dart';

class SubscribePage extends StatefulWidget {
  const SubscribePage({super.key});

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  bool? isSaudi;
  AppPrefs prefs = getIt<AppPrefs>();
  late SubscriptionCubit subscriptionCubit;

  @override
  void initState() {
    super.initState();
    subscriptionCubit = context.read<SubscriptionCubit>();
    subscriptionCubit.getSubscriptions();
    isSaudi = prefs.get(PrefKeys.countryId, defaultValue: false) == 2;
    print('is saudi $isSaudi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.subscribeNow2.tr()).header(),
        isCenterTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubscribtionHistoryPage())),
            icon: Icon(Icons.history),
            label: CustomText(
              LocaleKeys.subscribtionHistory.tr(),
              ph: 0,
            ).footerExtra(),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Assets.imagesBk2), fit: BoxFit.cover)),
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state.state == BaseState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.state == BaseState.error) {
              return ErrorLayout(
                  errorModel: state.error,
                  onRetry: () {
                    subscriptionCubit.getSubscriptions();
                  });
            }
            if (state.data.isEmpty) {
              return EmptyView(message: LocaleKeys.noSubscribtions.tr());
            }
            return SingleChildScrollView(
              child: ListAnimator(
                children: [
                  SizedBox(height: 24),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child:   Image.asset(
                      Assets.imagesLogo,
                      height: 70,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(LocaleKeys.chooseSubscribeNow.tr(),size: 20,ph: 25.w,bold:true,),
                    ...state.data.map((e) => _buildItem(e)).toList(),
                    _buildItemConst(),
                    SizedBox(height: 18),
                  ],
                )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _buildItem(SubscriptionModel subscriptionModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child:  FittedBox(
              child: Row(
                children: [
                  CustomText(subscriptionModel.name ?? "", color: primaryColor)
                      .headerExtra()
                      .start(),
                  SizedBox(width: 3.w,),
                  CustomText(
                      "${subscriptionModel.price.toString()} ${getCountryCurrency(context)}",
                      color: AppColorLight().kAccentColor)
                      .headerExtra(),],
              ),
            )),
          SizedBox(width: 5.w,),
          Expanded(
            flex: 1,
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1),
            child:
            CustomButton(
              height: 35.h,
              width: 112.w,
              onTap: () async {
                String paymentMethod = await context.read<SubscriptionCubit>().actionShowSubscriptionMethods(context: context, subscriptionModel: subscriptionModel!);
                bool status = await _showStatusDialog(subscriptionModel,paymentMethod);
                if(!status)return;
                UpdateSubscribtionResponse response = await subscriptionCubit.subscribe(id:subscriptionModel.id??0, method: paymentMethod, context: context);
                if (paymentMethod.isEmpty){
                  // NavigationService.push(RoutesProvider.paymentWebview, arguments: {'id': e.id, 'url': updateSubscribtionResponse?.paymentData?.redirectUrl});
                }else{
                }


                if (response.paymentData?.redirectUrl != null) {
                  NavigationService.push(RoutesProvider.paymentWebview, arguments: {'id': subscriptionModel.id, 'url': response.paymentData?.redirectUrl});
                } else if (response.paymentData?.kioskBillReference != null && mounted) {
                  AppDialogs().showKioskPaymentDialog(context, response.paymentData?.kioskBillReference ?? "");
                }




                // print('zozo ${updateSubscriptionResponse.paymentData?.redirectUrl}');
                // String paymentMethod = await context.read<SubscriptionCubit>().actionShowSubscriptionMethods(
                //       context: context,
                //       // url: '${updateSubscriptionResponse.paymentData?.redirectUrl}',
                //       subscriptionModel: subscriptionModel,
                //     );
                // if (paymentMethod.isEmpty) return;
                // else {
                //   actionSubscribe(subscriptionModel, paymentMethod);
                // }
              },
              title: LocaleKeys.subscribeNow2.tr(),
              fontSize: 16,
            ),
          ),)
        ],
      ),
    );
  }
  _buildItemConst() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child:  CustomText(LocaleKeys.subscribeNowConst.tr() ,size: 12, color: primaryColor,align: TextAlign.center)
                .headerExtra()
                .start(),),
          SizedBox(width: 3.w,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1),
            child:
            CustomButton(
              height: 35.h,
              width: 112.w,
              onTap: () async {
                bool isOk=await  AppDialogs().question(context,
                    buttonTitle1: LocaleKeys.subscribeNow2.tr(),
                    buttonTitle2: LocaleKeys.cancel.tr(),
                    message: LocaleKeys.subscribeMessage.tr());
                if(!isOk)return;
                UpdateSubscribtionResponse response = await subscriptionCubit.subscribe(method: 'percentage', context: context);

                // AppSnackbar.show(context: NavigationService.navigationKey.currentContext!, message: LocaleKeys.somethingWentWrong.tr());

              },
              title: LocaleKeys.subscribeNow2.tr(),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }


  void actionSubscribe(SubscriptionModel e, String selectedMethod) async {
    String desc = "";
    desc += "${LocaleKeys.price.tr()}: ${e.price} ${getCountryCurrency(context)}\n";
    desc += "${LocaleKeys.period.tr()}: ${e.period}\n";
    desc += "${LocaleKeys.paymentMethod.tr()}: ${convertToName(selectedMethod)} \n";

    //show dialog to confirm
    String message = "";
    message += "${LocaleKeys.confirmSubscribtion.tr()}\n";
    message += desc;
    bool status = await AppDialogs().question(context, message: message);
    if (!status) return;

    bool paymentMethodOnWeb = false;
    if(isSaudi==true){
      for (var item in CreditMethodsSaudi.values) {
        if (selectedMethod == item.name) {
          paymentMethodOnWeb = true;
          break;
        }
      }
    }else{
      for (var item in CreditMethodsEgypt.values) {
        if (selectedMethod == item.name) {
          paymentMethodOnWeb = true;
          break;
        }
      }
    }

    if (paymentMethodOnWeb) {
      actionPerformSubscribeWebPayment(e, selectedMethod);
    } else {
      actionPerformSubscribe(subscriptionModel: e, selectedMethod: selectedMethod, desc: desc);
    }
  }

  void actionPerformSubscribeWebPayment(SubscriptionModel subscriptionModel, String selectedMethod) async {
    try {
      UpdateSubscribtionResponse updateSubscribtionResponse = await context
          .read<SubscriptionCubit>()
          .subscribe(id:subscriptionModel.id??0, method: selectedMethod, context: context);

      kEcho(
          "paymentUrl: ${updateSubscribtionResponse.paymentData?.redirectUrl}");

      if (updateSubscribtionResponse.paymentData != null) {
        if (updateSubscribtionResponse.paymentData?.redirectUrl != null) {
          NavigationService.push(RoutesProvider.paymentWebview, arguments: {
            'id': subscriptionModel.id,
            'url': updateSubscribtionResponse.paymentData?.redirectUrl,
          });
        } else if (updateSubscribtionResponse.paymentData?.kioskBillReference !=
            null) {
          if (mounted) {
            AppDialogs().showKioskPaymentDialog(
              context,
              updateSubscribtionResponse.paymentData?.kioskBillReference ?? "",
            );
          }
        }
      } else {
        AppSnackbar.show(
          context: NavigationService.navigationKey.currentContext!,
          message: LocaleKeys.somethingWentWrong.tr(),
        );
        setState(() {});
      }
    } catch (e) {
      String errorMessge = "";
      if (e is ErrorModel) {
        errorMessge = e.errorMessage ?? "";
      }
      AppSnackbar.show(
        context: NavigationService.navigationKey.currentContext!,
        message: '${LocaleKeys.somethingWentWrong.tr()} \n $errorMessge',
      );

      setState(() {});
    }
  }

  void actionPerformSubscribe({
    required SubscriptionModel subscriptionModel,
    required String selectedMethod,
    required String desc,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(LocaleKeys.confirmSubscribtion.tr()),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(desc),
                SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          UpdateSubscribtionResponse response = await context.read<SubscriptionCubit>().subscribe(id:subscriptionModel.id??0, method: selectedMethod, context: context);
                          AppSnackbar.show(context: NavigationService.navigationKey.currentContext!, message: LocaleKeys.somethingWentWrong.tr());

                          setState(() {});
                        } catch (e) {
                          String errorMessage = "";
                          if (e is ErrorModel) {
                            errorMessage = e.errorMessage ?? "";
                          }
                          AppSnackbar.show(
                              context: NavigationService.navigationKey.currentContext!,
                              message: errorMessage);
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: CustomText(
                        LocaleKeys.confirm.tr(),
                        color: Colors.white,
                      ).headerExtra(),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: CustomText(
                        LocaleKeys.cancel.tr(),
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
  }
  _showStatusDialog( SubscriptionModel? subscription, String paymentMethod)async{
    String message = "";
    message += "${LocaleKeys.confirmSubscribtion.tr()}\n";
    message += "${LocaleKeys.price.tr()}: ${subscription!.price} ${getCountryCurrency(context)}\n";
    message += "${LocaleKeys.period.tr()}: ${subscription.period}\n";
    message += "${LocaleKeys.paymentMethod.tr()}: ${convertToName(paymentMethod)}\n";
    bool status = await AppDialogs().question(context, message: message);
    return status ;

  }
}

getCountryCurrency(BuildContext context) {
  ProfileProviderCubit profileProviderCubit = context.read<ProfileProviderCubit>();
  if (profileProviderCubit.state.data?.countryModel?.title == 'مصر') {
    return 'جنيه';
  } else if (profileProviderCubit.state.data?.countryModel?.title == 'السعودية') {
    return 'ريال';
  }
  return '';
}

enum SubscriptionMethods { request, wallet, credit }

enum CreditMethodsEgypt { visa, mobile_wallet, kiosk }
enum CreditMethodsSaudi { visa/*, apple */}

String convertToName(String title) {
  // if (title == CreditMethodsSaudi.apple.name.trim()) return LocaleKeys.apple.tr();
  if (title == CreditMethodsEgypt.visa.name.trim()) return LocaleKeys.visa.tr();
  if (title == CreditMethodsEgypt.mobile_wallet.name.trim()) return LocaleKeys.mobileWalletPayment.tr();
  if (title == CreditMethodsEgypt.kiosk.name.trim()) return LocaleKeys.kiosk.tr();
  if (title == SubscriptionMethods.request.name.trim()) return LocaleKeys.requestPayment.tr();
  if (title.contains(SubscriptionMethods.wallet.name.trim())) return LocaleKeys.wallet.tr();
  if (title == SubscriptionMethods.credit.name.trim()) return LocaleKeys.payBy.tr();

  return title;
}
