import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/features/logic/provider_service/services_cubit.dart';

import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
    //call before build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BlocProvider.of<ServicesProviderCubit>(context).getAllServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("الخدمات المقدمة").header(),
        isCenterTitle: true,
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: BlocConsumer<ServicesProviderCubit, ServicesProviderState>(
        buildWhen: (previous, current) => previous.services != current.services,
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
                if (state.services.isEmpty) return Center(child: CustomText(LocaleKeys.noServicesFound.tr()).header());
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Column(
                          children: [
                            for (final service in state.services) singleService(service),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
                      onTap: () {
                        logger.i('updateSelectedServices: ${state.services.where((element) => element.myService == true).toList()}}');
                        logger.e('updateSelectedServices: ${state.services.where((element) => element.myService == false).toList()}}');

                        if (state.services.where((element) => element.myService == true).isEmpty) {
                          AppSnackbar.show(
                            context: context,
                            type: SnackbarType.warning,
                            title: LocaleKeys.notification,
                            message: LocaleKeys.selectAtLeastOneService.tr(),
                          );
                          return;
                        }
                        BlocProvider.of<ServicesProviderCubit>(context).updateServices(state.services.where((element) => element.myService == true).toList());
                      },
                      loading: state.updateState == BaseState.loading,
                      title: LocaleKeys.confirm.tr(),
                    ),
                  ],
                );
              }
            case BaseState.error:
              return ErrorLayout(
                errorModel: state.error,
                onRetry: () {
                  BlocProvider.of<ServicesProviderCubit>(context).getAllServices();
                },
              );
          }
          return Container();
        },
      ),
    );
  }

  singleService(ServiceModel service) {
    return Builder(builder: (context) {
      return CheckboxListTile(
        value: service.myService ?? false,
        onChanged: (val) {
          BlocProvider.of<ServicesProviderCubit>(context).updateSelectedServices(service, !service.myService!);
        },
        title: Row(
          children: [
            SizedBox(width: 8),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(service.title ?? "N/A", pv: 0).header().start(),
                if (service.breif != null) CustomText(service.breif!, pv: 0).footer().start(),
              ],
            )),
          ],
        ),
      );
    });
  }
}
