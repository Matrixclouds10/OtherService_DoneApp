import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_subscription/subscription_cubit.dart';
import 'package:weltweit/features/screens/provider_subscribe/subscribtion_history_page.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/empty_widget.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class SubscribePage extends StatefulWidget {
  const SubscribePage({super.key});

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  @override
  void initState() {
    super.initState();
    SubscribtionCubit subscriptionCubit = context.read<SubscribtionCubit>();
    subscriptionCubit.getSubscribtions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("تفعيل الحساب").header(),
        isCenterTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //go to history screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => SubscribtionHistoryPage()));
            },
            icon: Icon(Icons.history),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBk2),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<SubscribtionCubit, SubscribtionState>(
          builder: (context, state) {
            if (state.state == BaseState.loading) return const Center(child: CircularProgressIndicator());
            if (state.state == BaseState.error) {
              return ErrorLayout(
                  errorModel: state.error,
                  onRetry: () {
                    context.read<SubscribtionCubit>().getSubscribtions();
                  });
            }
            if (state.data.isEmpty) return const EmptyView(message: "لا يوجد اشتراكات");
            return SingleChildScrollView(
              child: ListAnimator(
                children: [
                  SizedBox(height: 24),
                  Image.asset(
                    Assets.imagesLogo,
                    height: 90,
                    fit: BoxFit.fitHeight,
                  ),
                  ...state.data.map((e) => _buildItem(e)).toList(),
                  SizedBox(height: 64),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 24),
                  //   decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
                  //   child: Column(
                  //     children: [
                  //       CustomText("فعل حسابك واحصل علي تجربة عمل مميزة ", color: primaryColor).header(),
                  //       CustomText("300 ج", color: AppColorLight().kAccentColor).headerExtra(),
                  //       CustomText("سنويا", color: Colors.grey[500]!, pv: 0).headerExtra(),
                  //       Container(
                  //         margin: EdgeInsets.symmetric(horizontal: 24),
                  //         child: CustomButton(
                  //           onTap: () {
                  //             NavigationService.goBack();
                  //           },
                  //           title: "إشترك الان",
                  //           color: primaryColor,
                  //         ),
                  //       ),
                  //       SizedBox(height: 24),
                  //     ],
                  //   ),
                  // ),
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
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(subscriptionModel.name ?? "", color: primaryColor).headerExtra().start(),
                  CustomText("Period:${subscriptionModel.period}", color: Colors.grey[500]!, pv: 0).footer().start(),
                ],
              ).expanded(),
              CustomText("${subscriptionModel.price.toString()}\$", color: AppColorLight().kAccentColor).headerExtra(),
            ],
          ),
          SizedBox(height: 12),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: CustomButton(
              onTap: () {
                actionShowSubscriptionMethods(subscriptionModel);
              },
              title: LocaleKeys.subscribeNow.tr(),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void actionSubscribe(SubscriptionModel e, String selectedMethod) async {
    String desc = "";
    desc += "Price:${e.price}\$\n";
    desc += "Period:${e.period}\n";
    desc += "Method:$selectedMethod\n";
    Navigator.pop(context);

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
                          BaseResponse response = await context.read<SubscribtionCubit>().subscribe(e.id, selectedMethod);
                          AppSnackbar.show(context: context, message: response.message ?? "");
                        } catch (e) {
                          AppSnackbar.show(context: context, message: LocaleKeys.somethingWentWrong.tr());
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

  void actionShowSubscriptionMethods(SubscriptionModel subscriptionModel) {
    ProfileProviderCubit profileProviderCubit = context.read<ProfileProviderCubit>();
    List<String> subscreptionMethods = ["wallet", "credit", "request"];
    var selectedMethod = subscreptionMethods.first;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(LocaleKeys.subscribeNow.tr()),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CustomText('Price:${subscriptionModel.price}\$').footer().expanded(),
                    CustomText('Period:${subscriptionModel.period}').footer().expanded(),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    //radio select Wallet , credit card , cash
                    ...subscreptionMethods.map((e) {
                      String title = e;
                      if (e.contains("wallet")) e = "wallet (${profileProviderCubit.state.data?.wallet ?? ''})";
                      bool isEnable = e.contains("credit") ? false : true;
                      if (isEnable) {
                        if (e.contains("wallet")) {
                          double? wallet = double.tryParse(profileProviderCubit.state.data?.wallet.toString() ?? "") ?? 0;
                          isEnable = wallet >= double.parse(subscriptionModel.price.toString());
                        }
                      }
                      return RadioListTile(
                        value: e,
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          if (!e.contains("credit")) {
                            selectedMethod = value.toString();
                            setState(() {});
                          }
                        },
                        title: CustomText(
                          e,
                          color: e.contains("credit") ? Colors.grey : Colors.black,
                        ).start(),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      );
                    }).toList(),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        actionSubscribe(subscriptionModel, selectedMethod);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: CustomText(
                        LocaleKeys.subscribeNow.tr(),
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
}
