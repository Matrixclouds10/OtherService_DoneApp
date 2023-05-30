import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/routing/routes.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/features/logic/provider_service/services_cubit.dart';
import 'package:weltweit/features/screens/provider_layout/layout_cubit.dart';

import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorLight().kScaffoldBackgroundColor,
        appBar: CustomAppBar(
          isBackButtonExist: false,
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: CustomText(LocaleKeys.more.tr()).header(),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              SizedBox(height: 12),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    singleCustomListTile(
                        image: "assets/images/file.png",
                        text:  LocaleKeys.myFiles.tr(),
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(context, RoutesProvider.providerDocuments);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    BlocBuilder<ServicesProviderCubit, ServicesProviderState>(
                      buildWhen: (previous, current) => previous.services != current.services,
                      bloc: BlocProvider.of<ServicesProviderCubit>(context)..getSavedServices(),
                      builder: (context, state) {
                        return singleCustomListTile(
                            image: Assets.imagesCustomerSupport,
                            text: LocaleKeys.providedServices.tr(),
                            trailingText: "${state.services.length} ${LocaleKeys.services.tr()}",
                            onTap: () {
                              Navigator.pushNamed(context, RoutesProvider.providerServices);
                            });
                      },
                    ),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/file.png",
                        text:  LocaleKeys.ordersHistory.tr(),
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(context, RoutesProvider.providerOrders);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/internet.png",
                        text: LocaleKeys.language.tr(),
                        trailingText: (() {
                          Locale locale = EasyLocalization.of(context)!.locale;
                          if (locale.languageCode == "ar") {
                            return "العربية";
                          } else {
                            return "English";
                          }
                        }()),
                        onTap: () {
                          AppDialogs().languageDialog(context);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/info.png",
                        text: LocaleKeys.aboutUs.tr(),
                        trailingText:LocaleKeys.aboutUsNote.tr(),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.about);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/info.png",
                        text:  LocaleKeys.privacyPolicy.tr(),
                        trailingText:  LocaleKeys.privacyPolicy.tr(),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.policy);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/customer-service.png",
                        text:  LocaleKeys.contactUs.tr(),
                        trailingText: LocaleKeys.contactUsNote.tr(),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.contactUs);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/user.png",
                        text:  LocaleKeys.subscribeNow.tr(),
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(context, RoutesProvider.providerSubscribe);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                      image: Assets.imagesLogOut,
                      text: LocaleKeys.logOut.tr(),
                      trailingText: LocaleKeys.logOutNote.tr(),
                      onTap: () async {
                        bool status = await AppDialogs().confirm(
                          context,
                          message: LocaleKeys.logOutMessage.tr(),
                        );
                        if (status) {
                          if (context.mounted) context.read<LayoutProviderCubit>().setCurrentIndex(0);
                          NavigationService.logout();
                        }
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(height: 36),
            ],
          ),
        ));
  }

  Widget singleCustomListTile({
    required String image,
    required String text,
    required String? trailingText,
    required Function() onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Image.asset(image, width: 48, height: 48),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text, color: text.contains(LocaleKeys.exit.tr()) ? Colors.red : Colors.black, align: TextAlign.start, pv: 0),
                    if (trailingText != null) CustomText(trailingText, color: Colors.grey, align: TextAlign.start, pv: 0),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            ],
          ),
        ));
  }

  Widget textWithIcon({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.black),
        SizedBox(width: 4),
        CustomText(text, color: Colors.black, align: TextAlign.start, pv: 0),
      ],
    );
  }
}
