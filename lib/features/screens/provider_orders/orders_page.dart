import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/order_item_widget_client_info.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().reset();
    context.read<OrdersCubit>().getPendingOrders(typeIsProvider: true);
    context.read<OrdersCubit>().getCompletedOrders(typeIsProvider: true);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("سجل الطلبات").header(),
        isCenterTitle: true,
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListAnimator(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
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
                      singleTab(0, 'الجديدة'),
                      singleTab(1, "الحالية"),
                    ],
                  ),
                ),
                tabBody(),
              ],
            )
          ],
        ),
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

  tabBody() {
    switch (_tabController.index) {
      case 0:
        return newOrders();
      case 1:
        return currentOrders();
      default:
        return Container();
    }
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
          return Column(
            children: [
              Image.asset(Assets.imagesBaloon, height: 200, width: 200),
              SizedBox(height: 12),
              CustomText(LocaleKeys.noOrdersFound.tr(), color: AppColorLight().kAccentColor).header(),
            ],
          );
        }
        return Column(
          children: [
            ...state.pendingData
                .where((element) => element.statusCode!.toLowerCase() == 'provider_accept')
                .map((e) => GestureDetector(
                      onTap: () {},
                      child: OrderItemWidgetClient(orderModel: e),
                    ))
                .toList(),
          ],
        );
      },
    );
  }

  completedOrders() {
    return Column(
      children: [],
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
              CustomText(LocaleKeys.noOrdersFound.tr(), color: AppColorLight().kAccentColor).header(),
              SizedBox(height: 20),
            ],
          );
        }
        return Column(
          children: [
            ...state.pendingData
                .where((element) => element.statusCode!.toLowerCase() == 'pending')
                .map((e) => GestureDetector(
                      onTap: () {},
                      child: OrderItemWidgetClient(orderModel: e),
                    ))
                .toList(),
          ],
        );
      },
    );
  }

  Widget ratesAsStars(double d) {
    return Row(
      children: [
        for (var i = 0; i < d; i++) Icon(Icons.star, size: 12, color: Colors.yellow),
        for (var i = 0; i < 5 - d; i++) Icon(Icons.star, size: 12, color: Colors.grey),
      ],
    );
  }
}

getRandomTags() {
  List<String> tags = ["صيانة السباكة", "صيانة الكهرباء", "صيانة النظافة", "صيانة الكمبيوتر", "صيانة السيارات", "صيانة الأجهزة الكهربائية"];
  List<String> randomTags = [];

  randomTags.add(tags[Random().nextInt(tags.length)]);
  randomTags.add(tags[Random().nextInt(tags.length)]);
  if (Random().nextInt(tags.length) % 2 == 0) randomTags.removeLast();
  return randomTags.isNotEmpty ? [randomTags.first] : randomTags;
}

getRandomDate() {
  List<String> dates = ["07/01/2023", "07/02/2023", "07/03/2023", "07/04/2023", "07/05/2023", "07/06/2023"];
  return dates[Random().nextInt(dates.length)];
}

getRadomTime() {
  List<String> times = ["3 م : 5 م", "5 م : 7 م", "7 م : 9 م", "9 م : 11 م", "11 م : 1 ص", "1 ص : 3 ص"];
  return times[Random().nextInt(times.length)];
}