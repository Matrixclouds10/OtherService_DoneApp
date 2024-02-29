import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';

import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/notification/notification_model.dart';
import 'package:weltweit/features/logic/notification/notifications_cubit.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    context.read<NotificationsCubit>().getProviderNotifications();
    context.read<NotificationsCubit>().getProviderNotifications();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        BlocProvider.of<NotificationsCubit>(context).getMoreProviderNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.notifications.tr()).header(),
        isCenterTitle: true,
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.state == BaseState.initial) return CustomLoadingSpinner();
          if (state.state == BaseState.loading) return CustomLoadingSpinner();
          if (state.state == BaseState.error) {
            return ErrorLayout(
              errorModel: state.error,
              onRetry: () {
                BlocProvider.of<NotificationsCubit>(context).getProviderNotifications();
              },
            );
          }

          return Column(
            children: [
              if (state.notifications.isEmpty) Expanded(child: Center(child: CustomText(LocaleKeys.no_notifications.tr()))),
              if (state.notifications.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      return singleCustomListTile(state.notifications[index]);
                    },
                  ),
                ),
              SizedBox(height: 12),
              BlocBuilder<NotificationsCubit, NotificationsState>(
                buildWhen: (previous, current) => previous.loadMoreState != current.loadMoreState,
                builder: (context, state) {
                  if (state.loadMoreState == BaseState.loading) return CustomLoadingSpinner();
                  return Container();
                },
              ),
              SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Widget singleCustomListTile(NotificationModel e) {
    return GestureDetector(
      onTap: () {
        if (e.order != null) {
          NavigationService.push(
            RoutesProvider.providerOrderDetails,
            arguments: {"order": e.order},
          );
        }
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.grey, size: 40),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(e.type ?? "", color: Colors.black, align: TextAlign.start, pv: 0),
                    // CustomText(
                    //   e.,
                    //   color: Colors.grey,
                    //   align: TextAlign.start,
                    //   pv: 0,
                    //   size: 12,
                    // ),
                  ],
                ),
                CustomText(e.message ?? "", color: Colors.grey, align: TextAlign.start, pv: 0),
              ],
            )),
            const SizedBox(width: 12),
            if (e.serviceOrderId != null) Icon(Icons.arrow_forward_ios, color: servicesTheme.primaryColorLight, size: 24),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
