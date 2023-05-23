import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/wallet/wallet_model.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_wallet/wallet_cubit.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import 'package:weltweit/presentation/component/component.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    WalletCubit walletCubit = context.read<WalletCubit>();
    walletCubit.getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE67E23),
        appBar: CustomAppBar(
          isBackButtonExist: false,
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: CustomText(LocaleKeys.myWallet.tr()).header(),
          actions: const [],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesBk2),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.orange.withOpacity(0.8), BlendMode.darken),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<ProfileProviderCubit, ProfileProviderState>(
                builder: (context, state) {
                  String totalAmount = state.data?.wallet?.toString() ?? "0";
                  return Column(
                    children: [
                      SizedBox(height: 24),
                      CustomText(totalAmount, color: Colors.white, align: TextAlign.start, pv: 0, ph: 12, size: 28),
                      CustomText(LocaleKeys.totalAmount.tr(), color: Colors.white, align: TextAlign.start, pv: 0, ph: 12),
                      SizedBox(height: 24),
                    ],
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColorLight().kScaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          if (state.state == BaseState.loading) CustomLoadingSpinner(),
                          if (state.state == BaseState.error)
                            ErrorLayout(
                              errorModel: state.error,
                              onRetry: () => context.read<WalletCubit>().getWallet(),
                            ),
                          if (state.data.isEmpty)
                            Center(
                              child: CustomText("لا يوجد عمليات سابقة", color: Colors.black, align: TextAlign.start, pv: 0, ph: 12).header(),
                            ),
                          if (state.data.isNotEmpty)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...state.data.map((e) => _singleItem(e)).toList(),
                                    SizedBox(height: 64),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  _singleItem(WalletModel e) {
    String amount = e.amount != null && e.amount! > 0 ? "+ ${e.amount}" : e.amount.toString();
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("#${e.providerId}", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                  CustomText("${e.message}", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                ],
              ),
            ),
            CustomText("$amount ج", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
            SizedBox(width: 8),
          ],
        ));
  }
}