import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/services/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/features/services/logic/service/services_cubit.dart';
import 'package:weltweit/features/services/modules/layout/layout_cubit.dart';
import 'package:weltweit/features/services/modules/layout/widgets/navigation_tabs.dart';
import 'package:weltweit/presentation/component/component.dart';

class LayoutPage extends StatefulWidget {
  final int? _currentPage;
  const LayoutPage({
    Key? key,
    required int? currentPage,
  })  : _currentPage = currentPage,
        super(key: key);
  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  void initState() {
    NavigationService.navigationKey.currentContext!.read<ProfileCubit>().getProfile();
    NavigationService.navigationKey.currentContext!.read<ServicesCubit>().getHomeServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.state == BaseState.error) {
          if (state.error?.code == 401) {
            if (context.mounted) context.read<LayoutCubit>().setCurrentIndex(context: context, i: 0);
            NavigationService.logout();
          }
        }
      },
      builder: (context, state) {
        switch (state.state) {
          case BaseState.initial:
            break;
          case BaseState.loading:
            return Scaffold(body: CustomLoadingSpinner());
          case BaseState.loaded:
            return LayoutView();
          case BaseState.error:
            return Scaffold(
                body: ErrorLayout(
              errorModel: state.error,
              onRetry: () {
                BlocProvider.of<ProfileCubit>(context).getProfile();
                NavigationService.navigationKey.currentContext!.read<ServicesCubit>().getHomeServices();
              },
            ));
        }
        return Scaffold(body: Container(child: Text('N/A')));
      },
    );
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
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              },
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedIconTheme: const IconThemeData(),
              selectedItemColor: Theme.of(context).primaryColor,
              selectedLabelStyle: TextStyle(fontSize: 12),
              items: [
                ...kTabs.map(
                  (e) {
                    if (e.index == 2) return BottomNavigationBarItem(icon: Container(), label: '');

                    return BottomNavigationBarItem(
                      icon: Icon(
                        currentIndex == e.index ? e.selectIcon : e.unSelectIcon,
                        color: currentIndex == e.index ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
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
