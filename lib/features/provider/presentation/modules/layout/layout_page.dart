import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/notification/device_token.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/provider/logic/profile/profile_cubit.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/provider/presentation/modules/home/home_page_pending.dart';

import 'layout_cubit.dart';
import 'widgets/bottom_navigation_bar_widget.dart';
import 'widgets/navigation_tabs.dart';

class LayoutPage extends StatefulWidget {
  final int? currentPage;
  const LayoutPage({Key? key, required this.currentPage}) : super(key: key);
  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  void initState() {
    super.initState();
    //call after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? fcmToken = await getDeviceToken();
      // if (fcmToken != null) {
      //   if (context.mounted) BlocProvider.of<ProfileProviderCubit>(context).updateFcm(fcmToken);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileProviderCubit, ProfileProviderState>(
      listener: (context, state) {
        if (state.state == BaseState.error) {
          if (state.error?.code == 401) {
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
            return LayoutWidget();
          case BaseState.error:
            return Scaffold(
                body: ErrorLayout(
              errorModel: state.error,
              onRetry: () {
                BlocProvider.of<ProfileProviderCubit>(context).getProfile();
              },
            ));
        }
        return Scaffold(body: Container(child: Text('N/A')));
      },
    );
  }
}

class LayoutWidget extends StatelessWidget {
  const LayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<ProfileProviderCubit>().state.data;
    return BlocBuilder<LayoutProviderCubit, LayoutProviderState>(
      builder: (context, state) {
        if (state is LayoutInitial) {
          int currentIndex = state.currentIndex;
          final LayoutProviderCubit viewModel = BlocProvider.of<LayoutProviderCubit>(context);
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: WillPopScope(
              child: getPage(context: context, currentIndex: currentIndex),
              onWillPop: () async {
                if (currentIndex != 0) {
                  viewModel.setCurrentIndex(0);
                  return false;
                } else {
                  return true;
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBarWidget(
              onTap: viewModel.setCurrentIndex,
              currentIndex: currentIndex,
              tabs: kTabs,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget getPage({required BuildContext context, required int currentIndex}) {
    UserModel? user = context.read<ProfileProviderCubit>().state.data;
    if (currentIndex == 0) {
      if (user == null || user.approved == null || user.approved == 0) {
        return HomePageInActive();
      }
    }
    if (currentIndex == 1) {
      if (user == null || user.approved == null || user.approved == 0) {
        return ErrorLayout(
          errorModel: ErrorModel(
            errorMessage: 'Your account is not approved yet',
            code: 401,
            image: Assets.imagesPending,
          ),
        );
      }
    }
    return kTabs[currentIndex].initialRoute;
  }
}
