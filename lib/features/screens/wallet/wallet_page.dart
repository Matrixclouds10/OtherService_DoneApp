import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/data/models/wallet/wallet_model.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import 'package:weltweit/presentation/component/component.dart';

import '../../logic/wallet/wallet_cubit.dart';
import '../../widgets/app_snackbar.dart';
import '../layout/layout_cubit.dart';

class UserWalletPage extends StatefulWidget {
  const UserWalletPage({super.key});

  @override
  State<UserWalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<UserWalletPage> {
  @override
  void initState() {
    super.initState();
    WalletCubit walletCubit = context.read<WalletCubit>();
    walletCubit.getUserWallet();
  }
  int points = 0;
  String totalAmount='0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE67E23),
        // appBar: CustomAppBar(
        //   isBackButtonExist: false,
        //   isCenterTitle: true,
        //   color: Colors.white,
        //   titleWidget: CustomText(LocaleKeys.myWallet.tr()).header(),
        //   actions: const [],
        // ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesBk2),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.orange.withOpacity(0.8), BlendMode.darken),
              ),
            ),
            child:
            FutureBuilder<UserModel>(
                future: context.read<ProfileCubit>().getProfile(),
                builder: (context, state) {
                  totalAmount = state.data?.wallet?? "0";
                  points = state.data?.points??0;
                  return  Stack(
                      children: [
                        Image.asset(Assets.imagesBk2,
                          height:double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          color: Colors.orange.withOpacity(0.2),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // CustomText(LocaleKeys.myWallet.tr()).header(),
                            SizedBox(height: 30),

                            Column(
                              children: [
                                SizedBox(height: 30),
                                CustomText('${totalAmount=='null'?'0':totalAmount} ${LocaleKeys.rs.tr()}',
                                    color: Colors.white,
                                    align: TextAlign.start,
                                    pv: 0,
                                    ph: 12,
                                    size: 20),
                                SizedBox(height: 5),
                                CustomText(LocaleKeys.balance.tr(),
                                    size: 18,
                                    color: Colors.white,
                                    align: TextAlign.start,
                                    pv: 0,
                                    ph: 12),
                                SizedBox(height: 18),

                              ],
                            ),
                            SizedBox(height: 40),

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
                                        SizedBox(height: 70),
                                        if (state.state == BaseState.loading) CustomLoadingSpinner(),
                                        if (state.state == BaseState.error)
                                          ErrorLayout(
                                            errorModel: state.error,
                                            onRetry: () => context.read<WalletCubit>().getUserWallet(),
                                          ),
                                        if (state.data.isEmpty)
                                         Padding(
                                            padding: EdgeInsets.only(top: 150.h),
                                            child: Center(
                                              child: CustomText(LocaleKeys.emptyWallet.tr(), color: Colors.black, align: TextAlign.start, pv: 0, ph: 12).header(),
                                            ),  ),
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
                        Positioned(
                          top: 40.h,
                          right: 5,
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back, color: Colors.white,),
                            onPressed: (){
                              Navigator.pop(context);
                              },
                          ),
                        ),
                        Positioned(
                            top: 130.h,
                            left: 30,
                            right: 30,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [


                                InkWell(
                                  onTap: ()async{
                                    print("convert");
                                    if(points == 0) {
                                      AppSnackbar.show(context: context, message: "you haven't any points",type: SnackbarType.error);
                                      return;
                                    }
                                    bool res =await AppDialogs().question(context, message: LocaleKeys.questionConvert.tr());
                                    if(res){
                                      Future.delayed(Duration(seconds: 0), () {
                                        context.read<WalletCubit>().convertUserPoints();
                                      });
                                    }
                                  },
                                  child:
                                  BlocConsumer<WalletCubit,WalletState>(
                                      listener: (context, state) {
                                        context.read<ProfileCubit>().getProfile();

                                      },
                                      builder: (context,state){
                                    return

                                      state.convertState == BaseState.loading?
                                      CustomLoadingSpinner():
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12.h),
                                        width:130.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 7,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.cached_sharp, color: Colors.orange.withOpacity(0.9), size: 50),
                                            CustomText(LocaleKeys.convertPoints.tr(), color: Colors.black.withOpacity(0.5), align: TextAlign.start, pv: 0, ph: 8, size: 15),
                                          ],
                                        ),
                                      );


                                  }),
                                ),
                                SizedBox(width: 10.w,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12.h),
                                  width:130.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 7,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.wallet_outlined, color: Colors.orange.withOpacity(0.9), size: 50),
                                      CustomText('${points.toString()} ${LocaleKeys.points.tr()}', color: Colors.black.withOpacity(0.5), align: TextAlign.start, pv: 0, ph: 8, size: 15),
                                    ],
                                  ),
                                )


                              ],
                            )
                        ),
                      ]);

                })
        ));
  }

  _singleItem(WalletModel e) {
    String amount = e.amount != null && e.amount! > 0 ? "+ ${e.amount}" : e.amount.toString();
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 7,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("#${e.providerId??''}", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                  CustomText(e.message??'', align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                ],
              ),
            ),
            CustomText("$amount  ${LocaleKeys.rs.tr()}", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
            SizedBox(width: 8),
          ],
        ));
  }
}
