import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/order_item_widget.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/provider/presentation/modules/orders/orders_page.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';

import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<ProfileCubit>().state.data!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.my_location),
                  SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration().radius(radius: 4),
                    child: CustomText("الرياض", color: Colors.black),
                  ),
                ],
              ),
              CustomText("طلباتي").header(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesServices.servicesNotifications);
                  },
                  icon: Icon(Icons.notifications)),
            ],
          ),
        ),
        Divider(height: 0.5, color: Colors.grey[300]),
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: Colors.black,
            onTap: (index) {
              setState(() {});
            },
            unselectedLabelColor: Colors.grey,
            tabs: [
              singleTab(0, LocaleKeys.newWord.tr()),
              singleTab(1, LocaleKeys.current.tr()),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                color: AppColorLight().kScaffoldBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration().customColor(Colors.white).radius(radius: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText("${LocaleKeys.goodMorning.tr()}, ${user.name}").header(),
                              Spacer(),
                              Icon(Icons.circle, color: user.isAvailable() ? Color(0xff20CA6E) : Color(0xffEF2027)),
                            ],
                          ),
                          CustomText(LocaleKeys.goodMorningDesc.tr()),
                          Row(
                            children: [
                              Spacer(),
                              BlocBuilder<ProfileCubit, ProfileState>(
                                buildWhen: (previous, current) => previous.availabilityState != current.availabilityState,
                                builder: (context, state) {
                                  return CustomButton(
                                    onTap: () {
                                      context.read<ProfileCubit>().updateAvailability();
                                      if (user.isAvailable()) {
                                        context.read<ProfileCubit>().updateLocation(context);
                                      }
                                    },
                                    title: user.isAvailable() ? LocaleKeys.available.tr() : LocaleKeys.unavailable.tr(),
                                    radius: 4,
                                    height: 40,
                                    loading: state.availabilityState == BaseState.loading,
                                    expanded: false,
                                    color: user.isAvailable() ? Color(0xff20CA6E) : Color(0xffEF2027),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Image.asset(Assets.imagesBaloon, height: 200, width: 200),
                    SizedBox(height: 12),
                    CustomText(LocaleKeys.cantGetNewOrders.tr(), color: AppColorLight().kAccentColor).header(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          ...[
                            LocaleKeys.makeSureToSelectServicesYouProvide.tr(),
                            LocaleKeys.makeSureToUploadAllFiles.tr(),
                            LocaleKeys.makeSureToBeOnline.tr(),
                          ]
                              .map((e) => AppTextTile(
                                    title: CustomText(
                                      e,
                                      size: 16,
                                      pv: 0,
                                      align: TextAlign.start,
                                    ),
                                    isTitleExpanded: true,
                                    leading: Icon(Icons.circle, size: 12),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                color: AppColorLight().kScaffoldBackgroundColor,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    for (var i = 0; i < 4; i++)
                      OrderItemWidget(
                        avatar: Assets.imagesAvatar,
                        name: "مسعد معوض",
                        profession: "",
                        date: getRandomDate(),
                        time: getRadomTime(),
                        orderStatus: i % 2 == 0 ? "accepted" : "accepted",
                        price: i % 2 == 0 ? "300 ج" : "250 ج",
                        tags: getRandomTags(),
                      ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  singleTab(int index, String title) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffE67E23) : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomText(title, color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}
