import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/features/provider/logic/service/services_cubit.dart';
import 'package:weltweit/features/provider/presentation/modules/layout/layout_cubit.dart';

import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import '../home/home_page.dart';

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
          titleWidget: CustomText("المزيد").header(),
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
                    // singleCustomListTile(
                    //     image: "assets/images/file.png",
                    //     text: 'ملفاتي',
                    //     trailingText: "",
                    //     onTap: () {
                    //       Navigator.pushNamed(context, RoutesProvider.providerDocuments);
                    //     }),
                    // Divider(height: 2, color: Colors.grey[300]),
                   
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
                        text: 'سجل الطلبات',
                        trailingText: "٣ طلبات",
                        onTap: () {
                          Navigator.pushNamed(context, RoutesProvider.providerOrders);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                      image: "assets/images/internet.png",
                      text: 'اللغة',
                      trailingText: "العربية",
                      onTap: () {},
                    ),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/info.png",
                        text: 'من نحن',
                        trailingText: "تعرف علينا",
                        onTap: () {
                          Navigator.pushNamed(context, RoutesProvider.providerAboutUs);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        image: "assets/images/customer-service.png",
                        text: 'تواصل معنا',
                        trailingText: "نحن في خدمتك دائما",
                        onTap: () {
                          Navigator.pushNamed(context, RoutesProvider.providerContactUs);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    // singleCustomListTile(
                    //     image: "assets/images/user.png",
                    //     text: 'اشترك الان',
                    //     trailingText: "غير مفعل",
                    //     onTap: () {
                    //       Navigator.pushNamed(context, RoutesProvider.providerSubscribe);
                    //     }),
                    // Divider(height: 2, color: Colors.grey[300]),
                   
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
              Image.asset(image, width: 48, height: 48, color: Colors.black),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text, color: text.contains("خروج") ? Colors.red : Colors.black, align: TextAlign.start, pv: 0),
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
