// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/service_item_widget.dart';
import 'package:weltweit/features/services/logic/service/services_cubit.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    //call before build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await BlocProvider.of<ServicesCubit>(context).getAllServices();
      await BlocProvider.of<ServicesCubit>(context).getMoreServices();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        BlocProvider.of<ServicesCubit>(context).getMoreServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.allServices.tr()).header(),
        isCenterTitle: true,
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: BlocConsumer<ServicesCubit, ServicesState>(
        listenWhen: (previous, current) => previous.updateState != current.updateState,
        listener: (context, state) {
          if (state.updateState == BaseState.loaded) {
            AppSnackbar.show(context: context, title: LocaleKeys.notification, message: LocaleKeys.updateSuccessfully.tr());
          }
        },
        builder: (context, state) {
          switch (state.state) {
            case BaseState.initial:
              break;
            case BaseState.loading:
              return CustomLoadingSpinner();
            case BaseState.loaded:
              {
                if (state.services.isEmpty) return Center(child: CustomText("لا يوجد خدمات").header());
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.services.length,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: ServiceItemWidget(
                              serviceModel: state.services[index],
                              grid: false,
                              width: deviceWidth / 7,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    BlocBuilder<ServicesCubit, ServicesState>(
                      buildWhen: (previous, current) => previous.loadMoreState != current.loadMoreState,
                      builder: (context, state) {
                        if (state.loadMoreState == BaseState.loading) return CustomLoadingSpinner();
                        return Container();
                      },
                    ),
                    SizedBox(height: 12),
                  ],
                );
              }
            case BaseState.error:
              return ErrorLayout(
                errorModel: state.error,
                onRetry: () {
                  BlocProvider.of<ServicesCubit>(context).getAllServices();
                },
              );
          }
          return Container();
        },
      ),
    );
  }
}
