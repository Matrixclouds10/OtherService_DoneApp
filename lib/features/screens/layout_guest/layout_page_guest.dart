import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/logic/service/services_cubit.dart';
import 'package:weltweit/features/screens/layout/layout_cubit.dart';
import 'package:weltweit/features/screens/layout/widgets/navigation_tabs.dart';

class LayoutPageGuest extends StatefulWidget {
  // ignore: unused_field
  final int? _currentPage;
  const LayoutPageGuest({
    Key? key,
    required int? currentPage,
  })  : _currentPage = currentPage,
        super(key: key);
  @override
  State<LayoutPageGuest> createState() => _LayoutPageGuestState();
}

class _LayoutPageGuestState extends State<LayoutPageGuest> {
  @override
  void initState() {
    NavigationService.navigationKey.currentContext!
        .read<ServicesCubit>()
        .getHomeServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutView();
  }
}

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        if (state is LayoutInitial) {
          int currentIndex = state.currentIndex;
          final LayoutCubit viewModel = BlocProvider.of<LayoutCubit>(context);
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesServices.servicesSearch);
              },
              backgroundColor: servicesTheme.primaryColorLight,
              child: const Icon(Icons.search),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: WillPopScope(
              child: IndexedStack(
                index: currentIndex,
                children: [
                  ...kTabs.map((e) => e.initialRoute),
                ],
              ),
              onWillPop: () async {
                if (currentIndex != 0) {
                  viewModel.setCurrentIndex(i: 0, context: context);
                  return false;
                } else {
                  // _nestedNavigator.currentState!.maybePop();
                  return true;
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                viewModel.setCurrentIndex(i: value, context: context);
                if (value == 3) {
                  context
                      .read<OrdersCubit>()
                      .getPendingOrders(typeIsProvider: false);
                }
              },
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedIconTheme: const IconThemeData(),
              selectedItemColor: Theme.of(context).primaryColor,
              selectedLabelStyle: TextStyle(fontSize: 12),
              items: [
                ...kTabs.map(
                  (e) {
                    if (e.index == 2) {
                      return BottomNavigationBarItem(
                          icon: Container(), label: '');
                    }

                    return BottomNavigationBarItem(
                      icon: Icon(
                        currentIndex == e.index ? e.selectIcon : e.unSelectIcon,
                        color: currentIndex == e.index
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hintColor,
                      ),
                      label: tr(e.name),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
