import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/order_item_widget.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/widgets/empty_widget.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.myOrders.tr()).header(),
        isCenterTitle: true,
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListAnimator(
              physics: const NeverScrollableScrollPhysics(),
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
                      singleTab(0, LocaleKeys.current.tr()),
                      singleTab(1, LocaleKeys.theCompleted.tr()),
                      singleTab(2, LocaleKeys.theCancelled.tr()),
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
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomText(title, color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  tabBody() {
    switch (_tabController.index) {
      case 0:
        return currentOrders();
      case 1:
        return completedOrders();
      case 2:
        return cancelledOrders();
      default:
        return Container();
    }
  }

  currentOrders() {
    context.read<OrdersCubit>().getOrders();
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.state == BaseState.error) {
          return ErrorView(message: state.error?.errorMessage ?? "حدث خطأ ما");
        }
        if (state.state == BaseState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.state == BaseState.loaded && state.data.isEmpty) {
          return EmptyView(message: "لا يوجد طلبات");
        }
        return Column(
          children: [
            for (var i = 0; i < state.data.length; i++)
              GestureDetector(
                onTap: () {
                  NavigationService.push(RoutesServices.servicesOrderDetails, arguments: {
                    "orderModel": state.data[i],
                  });
                },
                child: OrderItemWidget(
                  orderModel: state.data[i],
                  avatar: state.data[i].provider?.image ?? '',
                  name: state.data[i].provider?.name ?? '',
                  profession: '',
                  date: DateFormat('yyyy-MM-dd').format(state.data[i].date),
                  time: DateFormat('HH:mm').format(state.data[i].date),
                  orderStatus: state.data[i].status,
                  price: '',
                  tags: const [],
                ),
              )
          ],
        );
      },
    );
  }

  completedOrders() {
    return Column(
      children: [
        for (var i = 0; i < 4; i++)
          OrderItemWidget(
            orderModel: null,
            avatar: Assets.imagesAvatar,
            name: "مسعد معوض",
            profession: getRandomTags()[0],
            date: getRandomDate(),
            time: getRadomTime(),
            orderStatus: "completed",
            price: "${100 * (i + 1)} ج",
            tags: getRandomTags(),
          )
      ],
    );
  }

  cancelledOrders() {
    return Column(
      children: [
        for (var i = 0; i < 4; i++)
          OrderItemWidget(
            orderModel: null,
            avatar: Assets.imagesAvatar,
            name: "مسعد معوض",
            profession: getRandomTags()[0],
            date: "",
            time: "",
            orderStatus: "cancelled",
            price: "",
            tags: getRandomTags(),
          )
      ],
    );
  }

  Widget ratesAsStars(double d) {
    return Row(
      children: [
        for (var i = 0; i < d; i++) const Icon(Icons.star, size: 12, color: Colors.yellow),
        for (var i = 0; i < 5 - d; i++) const Icon(Icons.star, size: 12, color: Colors.grey),
      ],
    );
  }

  getRandomTags() {
    List<String> tags = ["صيانة السباكة", "صيانة الكهرباء", "صيانة النظافة", "صيانة الكمبيوتر", "صيانة السيارات", "صيانة الأجهزة الكهربائية"];
    List<String> randomTags = [];

    randomTags.add(tags[Random().nextInt(tags.length)]);
    randomTags.add(tags[Random().nextInt(tags.length)]);
    if (Random().nextInt(tags.length) % 2 == 0) randomTags.removeLast();
    return randomTags;
  }

  getRandomDate() {
    List<String> dates = ["07/01/2023", "07/02/2023", "07/03/2023", "07/04/2023", "07/05/2023", "07/06/2023"];
    return dates[Random().nextInt(dates.length)];
  }

  getRadomTime() {
    List<String> times = ["3 م : 5 م", "5 م : 7 م", "7 م : 9 م", "9 م : 11 م", "11 م : 1 ص", "1 ص : 3 ص"];
    return times[Random().nextInt(times.length)];
  }
}
