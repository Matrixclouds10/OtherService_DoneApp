import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/order_item_widget_client_info.dart';
import 'package:weltweit/features/logic/home/home_cubit.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';

import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<OrdersCubit>().getPendingOrders(typeIsProvider: true);
    context.read<OrdersCubit>().getCompletedOrders(typeIsProvider: true);
    context.read<HomeCubit>().getCurrentLocationAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProfileProviderCubit, ProfileProviderState>(
        builder: (context, state) {
          return Column(children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state.currentLocationAddress.isNotEmpty) {
                        return Expanded(
                          child: Tooltip(
                            message: state.currentLocationAddress,
                            triggerMode: TooltipTriggerMode.tap,
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: Colors.black54),
                                Expanded(
                                  child: Container(child: CustomText(state.currentLocationAddress, maxLines: 1).footer().start()),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(width: 8),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesProvider.providerNotifications);
                      },
                      icon: Icon(FontAwesomeIcons.bell)),
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
                  if (index == 0) {
                    context.read<OrdersCubit>().getPendingOrders(typeIsProvider: true);
                  } else {
                    context.read<OrdersCubit>().getCompletedOrders(typeIsProvider: true);
                  }
                  setState(() {});
                },
                unselectedLabelColor: Colors.grey,
                tabs: [
                  singleTab(0, LocaleKeys.newOrders.tr()),
                  singleTab(1, LocaleKeys.current.tr()),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
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
                                  CustomText("${LocaleKeys.goodMorning.tr()}, ${state.data?.name ?? ''}").header(),
                                  Spacer(),
                                  Icon(Icons.circle, color: state.data?.isAvailable() ?? false ? Color(0xff20CA6E) : Color(0xffEF2027)),
                                ],
                              ),
                              CustomText(LocaleKeys.goodMorningDesc.tr()),
                              Row(
                                children: [
                                  Spacer(),
                                  BlocBuilder<ProfileProviderCubit, ProfileProviderState>(
                                    buildWhen: (previous, current) => previous.availabilityState != current.availabilityState,
                                    builder: (context, state) {
                                      return CustomButton(
                                        onTap: () {
                                          if (state.data?.currentSubscription != null) {
                                            context.read<ProfileProviderCubit>().updateAvailability();
                                            if (state.data?.isAvailable() ?? false) {
                                              context.read<ProfileProviderCubit>().updateLocation(context);
                                            }
                                          } else {
                                            AppSnackbar.show(context: context, message: LocaleKeys.youNeedToSubscribe.tr());
                                          }
                                        },
                                        title: state.data?.isAvailable() ?? false ? LocaleKeys.available.tr() : LocaleKeys.unavailable.tr(),
                                        radius: 4,
                                        height: 40,
                                        loading: state.availabilityState == BaseState.loading,
                                        expanded: false,
                                        color: state.data?.isAvailable() ?? false ? Color(0xff20CA6E) : Color(0xffEF2027),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Expanded(child: newOrders()),
                      ],
                    ),
                  ),
                  Container(
                    color: AppColorLight().kScaffoldBackgroundColor,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      children: [
                        currentOrders(),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
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

  Widget currentOrders() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.pendingState == BaseState.error) {
          return ErrorView(message: state.error?.errorMessage ?? "حدث خطأ ما");
        }
        if (state.pendingState == BaseState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.pendingState == BaseState.loaded && state.pendingData.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(Assets.imagesBaloon, height: 160, width: 160),
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
                      SizedBox(height: 60),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ...state.pendingData
                  .where((element) => element.statusCode?.toLowerCase() == 'provider_accept')
                  .map((e) => GestureDetector(
                        onTap: () {},
                        child: OrderItemWidgetClient(
                          orderModel: e,
                          // name: state.pendingData[i].provider?.name ?? '',
                          // profession: '',
                          // date: DateFormat('yyyy-MM-dd').format(state.pendingData[i].date),
                          // time: DateFormat('HH:mm').format(state.pendingData[i].date),
                          // orderStatus: state.pendingData[i].status,
                          // price: '',
                          // tags: const [],
                        ),
                      ))
                  .toList(),
              SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  Widget newOrders() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.pendingState == BaseState.error) {
          return ErrorView(message: state.error?.errorMessage ?? "حدث خطأ ما");
        }
        if (state.pendingState == BaseState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.pendingState == BaseState.loaded && state.pendingData.isEmpty) {
          return Column(
            children: [
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
          );
        }
        return Column(
          children: [
            ...state.pendingData
                .where((element) => element.statusCode?.toLowerCase() == 'pending')
                .map((e) => GestureDetector(
                      onTap: () {},
                      child: OrderItemWidgetClient(
                        orderModel: e,
                      ),
                    ))
                .toList(),
          ],
        );
      },
    );
  }
}
