import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/dialog/base/simple_dialogs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: servicesTheme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          isBackButtonExist: false,
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: const CustomText("حسابي").header(),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.black),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RoutesServices.servicesProfileEdit);
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  NavigationService.push(RoutesServices.servicesProfileEdit);
                },
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state.data == null) {
                      return Container();
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImage(
                            imageUrl: state.data!.image,
                            width: MediaQuery.of(context).size.width / 7,
                            height: MediaQuery.of(context).size.width / 7,
                            fit: BoxFit.fill,
                            radius: 250,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                textWithIcon(
                                    icon: Icons.person,
                                    text: state.data!.name ?? ''),
                                const SizedBox(height: 4),
                                textWithIcon(
                                    icon: Icons.phone,
                                    text: state.data!.mobileNumber ?? ''),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              const CustomText("معلوماتي",
                      color: Colors.black,
                      align: TextAlign.start,
                      bold: true,
                      pv: 0,
                      ph: 12)
                  .header(),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: 'عناويني',
                        trailingText: "(5 عناوين)",
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutesServices.servicesMyAddresses);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: 'طلباتي',
                        trailingText: "(3 طلبات)",
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutesServices.servicesOrders);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: 'اللغة',
                        trailingText: "العربية",
                        onTap: () {}),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: 'من نحن',
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutesServices.servicesAboutUs);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: 'تواصل معنا',
                        trailingText: "",
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutesServices.servicesContactUs);
                        }),
                    Divider(height: 2, color: Colors.grey[300]),
                    singleCustomListTile(
                        icon: Icons.arrow_forward_ios,
                        text: 'تسجيل خروج',
                        trailingText: "",
                        onTap: () {
                          AppDialogs().logoutDialog(context);
                        }),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget singleCustomListTile({
    required IconData icon,
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
              Expanded(
                  child: CustomText(text,
                      color: text.contains("خروج") ? Colors.red : Colors.black,
                      align: TextAlign.start,
                      pv: 0)),
              if (trailingText != null)
                CustomText(trailingText,
                    color: Colors.grey, align: TextAlign.start, pv: 0),
              const SizedBox(width: 12),
              Icon(icon, size: 16, color: Colors.grey),
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
        const SizedBox(width: 4),
        CustomText(text, color: Colors.black, align: TextAlign.start, pv: 0),
      ],
    );
  }
}