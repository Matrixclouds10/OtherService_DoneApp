import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'dart:io';
import '../../../core/utils/toast_states/enums.dart';

class ServiceProviderItemWidget extends StatelessWidget {
  final ProvidersModel providersModel;
  final bool? canMakeAppointment;
  final bool? moreInfoButton;
  final bool showFavoriteButton;
  final UserModel? userModel;

  const ServiceProviderItemWidget({
    required this.providersModel,
    this.canMakeAppointment,
    this.moreInfoButton,
    required this.showFavoriteButton,
    super.key,
    this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: CustomImage(
                  imageUrl: providersModel.image,
                  width: MediaQuery.of(context).size.width / 7,
                  height: MediaQuery.of(context).size.width / 7,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(providersModel.name ?? "N/A", color: Colors.black, align: TextAlign.start, pv: 0),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // if (canMakeAppointment != null && canMakeAppointment!)
                            //   GestureDetector(
                            //     onTap: () {
                            //       Navigator.pushNamed(context, RoutesServices.servicesReservationPage, arguments: {
                            //         "providersModel": providersModel,
                            //       });
                            //     },
                            //     child: Container(
                            //       margin: const EdgeInsets.only(bottom: 6),
                            //       decoration: BoxDecoration(color: servicesTheme.colorScheme.secondary).radius(radius: 4),
                            //       child:  CustomText(
                            //         LocaleKeys.makeAppointment.tr(),
                            //         color: Colors.white,
                            //         pv: 6,
                            //       ),
                            //     ),
                            //   ),
                            if (providersModel.rateAvg != null && canMakeAppointment == null) ratesAsStars(double.parse(providersModel.rateAvg!), providersModel.rateCount ?? 0),
                            if (showFavoriteButton)
                              IconButton(
                                icon: Icon(
                                  providersModel.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: providersModel.isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () async {
                                  await context.read<FavoriteCubit>().addFavorite(providersModel.id!);
                                  if (context.mounted) context.read<FavoriteCubit>().getFavorite();
                                },
                              ),
                          ],
                        )
                      ],
                    ),
                    if (providersModel.services != null)
                      Wrap(
                        children: [
                          ...providersModel.services!
                              .map((e) => CustomText(
                                    e.title ?? "N/A",
                                    color: Colors.grey,
                                    align: TextAlign.start,
                                    pv: 0,
                                    ph: 4,
                                  ).footerExtra())
                              .toList(),
                        ],
                      ),
                    // CustomText('no profession', color: Colors.grey, align: TextAlign.start, pv: 0),
                    if (providersModel.description != null && providersModel.description!.isNotEmpty) CustomText(providersModel.description ?? "", maxLines: 2, color: Colors.grey, align: TextAlign.start, pv: 4).footer(),
                    SizedBox(height: 4),
                    // if (address != null)
                    // textWithIcon(
                    //   icon: Icons.location_on,
                    //   text: 'no address',
                    // ),
                    Row(
                      children: [
                        if (providersModel.distance != null)
                          textWithIcon(
                            icon: Icons.route,
                            text: '${providersModel.distance!}',
                          ),
                        if (providersModel.isOnline)
                          Container(
                            decoration: const BoxDecoration(color: Color(0xff00A35E)).radius(radius: 4),
                            child: CustomText(
                              LocaleKeys.available.tr(),
                              color: Colors.white,
                              pv: 2,
                              ph: 8,
                              size: 14,
                            ),
                          ),
                        SizedBox(width: 4),
                      ],
                    ),
                    if (userModel != null && userModel!.currentSubscription != null) ...[
                      SizedBox(height: 4),
                      Container(
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 33, 136, 255)).radius(radius: 4),
                        child: CustomText(
                          "${LocaleKeys.subscribtionStatus.tr()} ${userModel!.currentSubscription!.status}",
                          color: Colors.white,
                          pv: 2,
                          ph: 8,
                          size: 14,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          if(userModel?.code != null && userModel?.code?.code != null)
          InkWell(
            onTap: ()async{
              // final res = await _getAndroidVersion();
              Clipboard.setData(ClipboardData(text: userModel?.code?.code ?? '')).then((_) {
                showToast(text: '${LocaleKeys.copied.tr()} ${userModel?.code?.code ?? ''}', gravity:  ToastGravity.TOP,);
                // if(res.isNotEmpty){
                //   final androidVersion = int.parse(res);
                //   if(Platform.isAndroid){
                //   if (androidVersion <= 10) {
                //     showToast(text: '${LocaleKeys.copied.tr()} ${userModel?.code?.code ?? ''}', gravity:  ToastGravity.TOP,);
                //   }
                // }
                //   else{
                //     showToast(text: '${LocaleKeys.copied.tr()} ${userModel?.code?.code ?? ''}', gravity:  ToastGravity.TOP,);
                //   }
                // }

              });
            },
            child: Column(
              children: [
                ...[
                  const SizedBox(height: 8),
                  textWithIcon(icon: Icons.copy_all_outlined, text: userModel?.code?.code ?? '', size: 25, fontSize: 18),
                ]
              ],
            ),
          ),
          if (moreInfoButton != null && moreInfoButton!)
            Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(color: servicesTheme.colorScheme.secondary).radius(radius: 45),
              child:  CustomText(
                LocaleKeys.moreInfo.tr(),
                color: Colors.white,
                pv: 6,
                ph: 40,
              ),
            ),
        ],
      ),
    );
  }

  Widget ratesAsStars(double rate, int rateCount) {
    return Row(
      children: [
        for (var i = 0; i < rate; i++) const Icon(Icons.star, size: 12, color: Colors.yellow),
        for (var i = 0; i < 5 - rate; i++) const Icon(Icons.star, size: 12, color: Colors.grey),
        CustomText(' ($rateCount)', color: Colors.grey, align: TextAlign.start, pv: 0).footer(),
      ],
    );
  }
  Future<String> _getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
   return androidInfo.version.release;
  }
  Widget textWithIcon({
    required IconData icon,
     double? size,
     double? fontSize,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size:size?? 16, color: Colors.grey),
        const SizedBox(width: 4),
        CustomText(text, color: Colors.grey, align: TextAlign.start, pv: 0,size: fontSize?? 14),
      ],
    );
  }
}
