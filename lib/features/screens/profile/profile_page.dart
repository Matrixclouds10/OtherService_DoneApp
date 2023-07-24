import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/routing/routes.dart';
import 'package:weltweit/core/utils/globals.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/screens/my_addresses/logic/address_cubit.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalParams globalParams = getIt();
    return Scaffold(
        backgroundColor: servicesTheme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          isBackButtonExist: false,
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: CustomText(LocaleKeys.myProfile.tr()).header(),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pushNamed(RoutesServices.servicesProfileEdit);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              _userProfileCard(context),
              const SizedBox(height: 8),
              CustomText(LocaleKeys.myInformation.tr(), color: Colors.black, align: TextAlign.start, bold: true, pv: 4, ph: 12).header(),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    BlocBuilder<AddressCubit, AddressState>(
                      builder: (context, state) {
                        return singleCustomListTile(
                            icon: Icons.arrow_forward_ios,
                            text: LocaleKeys.myAddresses.tr(),
                            trailingText: state.addresses.isNotEmpty ? "(${state.addresses.length} ${LocaleKeys.address.tr()})" : "",
                            onTap: () {
                              Navigator.pushNamed(context, RoutesServices.servicesMyAddresses);
                            });
                      },
                    ),
                    Divider(height: 2, color: Colors.grey[300]),
                    BlocBuilder<OrdersCubit, OrdersState>(
                      builder: (context, state) {
                        return singleCustomListTile(
                            icon: Icons.arrow_forward_ios,
                            text: LocaleKeys.myOrders.tr(),
                            trailingText: state.pendingData.isNotEmpty ? "(${state.pendingData.length} طلب)" : "",
                            onTap: () {
                              Navigator.pushNamed(context, RoutesServices.servicesOrders);
                            });
                      },
                    ),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: LocaleKeys.language.tr(),
                        trailingText: (() {
                          Locale locale = EasyLocalization.of(context)!.locale;
                          if (locale.languageCode == "ar") {
                            return "العربية";
                          } else {
                            return "English";
                          }
                        }()),
                        onTap: () async {
                          await AppDialogs().languageDialog(context);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: LocaleKeys.aboutUs.tr(),
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(context, Routes.about);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: LocaleKeys.privacyPolicy.tr(),
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(context, Routes.policy);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: LocaleKeys.contactUs.tr(),
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(context, Routes.contactUs);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state.data == null) {
                          return singleCustomListTile(
                              icon: Icons.arrow_forward_ios,
                              text: LocaleKeys.login.tr(),
                              trailingText: "",
                              onTap: () {
                                NavigationService.pushNamedAndRemoveUntil(RoutesServices.servicesWelcomeScreen);
                              });
                        }

                        return singleCustomListTile(
                            icon: null,
                            text: LocaleKeys.logOut.tr(),
                            trailingText: "",
                            onTap: () {
                              AppDialogs().logoutDialog(context);
                            });
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 90),
            ],
          ),
        ));
  }

  Widget singleCustomListTile({
    required IconData? icon,
    required String text,
    required String? trailingText,
    required Function() onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Expanded(child: CustomText(text, color: text.contains("خروج") ? Colors.red : Colors.black, align: TextAlign.start, pv: 0)),
              if (trailingText != null) CustomText(trailingText, color: Colors.grey, align: TextAlign.start, pv: 0),
              const SizedBox(width: 12),
              if (icon != null) Icon(icon, size: 16, color: Colors.grey),
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
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 4),
        CustomText(text, color: Colors.black87, align: TextAlign.start, pv: 0),
      ],
    );
  }

  _userProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.push(RoutesServices.servicesProfileEdit);
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.data == null) {
            return Container();
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImage(
                  imageUrl: state.data!.image,
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                  fit: BoxFit.fill,
                  radius: 250,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      textWithIcon(icon: Icons.person, text: state.data!.name ?? ''),
                      const SizedBox(height: 4),
                      textWithIcon(icon: Icons.phone, text: state.data!.mobileNumber ?? ''),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
