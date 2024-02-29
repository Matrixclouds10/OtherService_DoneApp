import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/order_item_widget.dart';
import 'package:weltweit/core/resources/theme/theme.dart';

import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/widgets/empty_widget.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class OrdersPage extends StatefulWidget {
  final bool canGoBack;
  const OrdersPage({required this.canGoBack, super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().reset();
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
        isBackButtonExist: widget.canGoBack,
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.black,
              onTap: (index) {
                if (index == 0) {
                  context.read<OrdersCubit>().getPendingOrders(typeIsProvider: false);
                }

                if (index == 1) {
                  context.read<OrdersCubit>().getCompletedOrders(typeIsProvider: false);
                }

                if (index == 2) {
                  context.read<OrdersCubit>().getCancelledOrders(typeIsProvider: false);
                }

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  tabBody(),
                ],
              ),
            ),
          ),
        ],
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
          color: isSelected ? const Color(0xffE67E23) : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomText(title, color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  tabBody() {
    switch (_tabController.index) {
      case 0:
        if (context.read<OrdersCubit>().state.pendingData.isEmpty) {
          context.read<OrdersCubit>().getPendingOrders(typeIsProvider: false);
        }
        return currentOrders();
      case 1:
        if (context.read<OrdersCubit>().state.completedData.isEmpty) {
          context.read<OrdersCubit>().getCompletedOrders(typeIsProvider: false);
        }
        return completedOrders();
      case 2:
        if (context.read<OrdersCubit>().state.cancelledData.isEmpty) {
          context.read<OrdersCubit>().getCancelledOrders(typeIsProvider: false);
        }
        return cancelledOrders();
      default:
        return Container();
    }
  }

  currentOrders() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.pendingState == BaseState.error) {
          return ErrorView(
            message: state.error?.errorMessage ?? "حدث خطأ ما",
            onRetry: () {
              context.read<OrdersCubit>().getPendingOrders(typeIsProvider: false);
            },
          );
        }
        if (state.pendingState == BaseState.loading) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }
        if (state.pendingState == BaseState.loaded && state.pendingData.isEmpty) {
          return EmptyView(message: LocaleKeys.noOrdersFound.tr());
        }
        return Column(
          children: [
            for (var i = 0; i < state.pendingData.length; i++)
              GestureDetector(
                onTap: () {
                  NavigationService.push(RoutesServices.servicesOrderDetails, arguments: {
                    "orderModel": state.pendingData[i],
                  });
                },
                child: OrderItemWidget(
                  orderModel: state.pendingData[i],
                  // name: state.pendingData[i].provider?.name ?? '',
                  // profession: '',
                  // date: DateFormat('yyyy-MM-dd').format(state.pendingData[i].date),
                  // time: DateFormat('HH:mm').format(state.pendingData[i].date),
                  // orderStatus: state.pendingData[i].status,
                  // price: '',
                  // tags: const [],
                ),
              ),
            SizedBox(height: 72),
          ],
        );
      },
    );
  }

  completedOrders() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.completedState == BaseState.error) {
          return ErrorView(
            message: state.error?.errorMessage ?? "حدث خطأ ما",
            onRetry: () {
              context.read<OrdersCubit>().getCompletedOrders(typeIsProvider: false);
            },
          );
        }
        if (state.completedState == BaseState.loading) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }
        if (state.completedState == BaseState.loaded && state.completedData.isEmpty) {
          return EmptyView(message: LocaleKeys.noOrdersFound.tr());
        }
        return Column(
          children: [
            for (var i = 0; i < state.completedData.length; i++)
              GestureDetector(
                onTap: () {
                  NavigationService.push(RoutesServices.servicesOrderDetails, arguments: {
                    "orderModel": state.completedData[i],
                  });
                },
                child: OrderItemWidget(
                  orderModel: state.completedData[i],
                ),
              ),
            SizedBox(height: 72),
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
                  NavigationService.push(RoutesServices.servicesOrderDetails, arguments: {
                    "orderModel": state.cancelledData[i],
                  });
                },
                child: OrderItemWidget(
                  orderModel: state.cancelledData[i],
                ),
              ),
            SizedBox(height: 72),
          ],
        );
      },
    );
  }
}
