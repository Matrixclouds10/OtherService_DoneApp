import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/order_item_widget_client_info.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

import '../../../core/routing/navigation_services.dart';
import '../../core/routing/routes_user.dart';
import '../../widgets/empty_widget.dart';

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.ordersHistory.tr()).header(),
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
                      if (index == 0) {
                        context.read<OrdersCubit>().getPendingOrders(typeIsProvider: true);
                      }
                      if (index == 1) {
                        context.read<OrdersCubit>().getPendingOrders(typeIsProvider: true);
                      }
                      if (index == 2) {
                        context.read<OrdersCubit>().getCompletedOrders(typeIsProvider: true);
                      }
                      if (index == 3) {
                        context.read<OrdersCubit>().getCancelledOrders(typeIsProvider: true);
                      }
                      setState(() {});
                    },
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      singleTab(0, LocaleKeys.newOrders.tr()),
                      singleTab(1, LocaleKeys.current.tr()),
                      singleTab(2, LocaleKeys.theCompleted.tr()),
                      singleTab(3, LocaleKeys.theCancelled.tr()),
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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomText(title, color: isSelected ? Colors.white : Colors.black),),
      ),
    );
  }

  tabBody() {
    switch (_tabController.index) {
      case 0:
        return newOrders();
      case 1:
        return currentOrders();
      case 2:
        return completedOrders();
        case 3:
        return cancelledOrders();
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
                .where((element) => element.statusCode!.toLowerCase() == 'provider_accept' || element.statusCode!.toLowerCase() == 'provider_finish'|| element.statusCode!.toLowerCase() == 'in_way')
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
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.completedState == BaseState.error) {
          return ErrorView(message: state.error?.errorMessage ?? "حدث خطأ ما");
        }
        if (state.completedState == BaseState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.completedState == BaseState.loaded && state.completedData.isEmpty) {
          return Column(
            children: [
              SizedBox(height: 12),
              CustomText(LocaleKeys.noOrdersFound.tr(), color: AppColorLight().kAccentColor).header(),
            ],
          );
        }
        return Column(
          children: [
            ...state.completedData
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
  cancelledOrders() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.cancelledState == BaseState.error) {
          return ErrorView(
            message: state.error?.errorMessage ?? "حدث خطأ ما",
            onRetry: () {
              context.read<OrdersCubit>().getCancelledOrders(typeIsProvider: false);
            },
          );
        }
        if (state.cancelledState == BaseState.loading) {
          return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
        }
        if (state.cancelledState == BaseState.loaded && state.cancelledData.isEmpty) {
          return EmptyView(message: LocaleKeys.noOrdersFound.tr());
        }
        return Column(
          children: [
            for (var i = 0; i < state.cancelledData.length; i++)
              GestureDetector(
                onTap: () {

                },
                child: OrderItemWidgetClient(
                  orderModel: state.cancelledData[i],
                ),
              ),
            SizedBox(height: 72),
          ],
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
