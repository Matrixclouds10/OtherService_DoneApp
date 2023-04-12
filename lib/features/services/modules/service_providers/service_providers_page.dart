import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/services/core/base/base_states.dart';
import 'package:weltweit/features/services/core/routing/routes.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import 'package:weltweit/features/services/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/services/logic/provider/providers_cubit.dart';
import 'package:weltweit/presentation/component/component.dart';

class ServiceProvidersPage extends StatefulWidget {
  final ServiceModel service;
  const ServiceProvidersPage({required this.service, super.key});

  @override
  State<ServiceProvidersPage> createState() => _ServiceProvidersPageState();
}

class _ServiceProvidersPageState extends State<ServiceProvidersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProvidersParams params = ProvidersParams(service_id: widget.service.id ?? 0);
      await BlocProvider.of<ProvidersCubit>(context).getProviders(params);
    });
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(widget.service.title ?? '').header(),
        isCenterTitle: true,
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: BlocBuilder<ProvidersCubit, ProvidersState>(
        builder: (context, state) {
          switch (state.state) {
            case BaseState.initial:
              break;
            case BaseState.loading:
              return CustomLoadingSpinner();
            case BaseState.loaded:
              {
                if (state.providers.isEmpty) return Center(child: CustomText("لا يوجد خدمات").header());

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      ListAnimator(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: [
                          const SizedBox(height: 12),
                          for (var i = 0; i < state.providers.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, RoutesServices.servicesProvider, arguments: {
                                  "provider": state.providers[i],
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.white).radius(radius: 12),
                                child: ServiceProviderItemWidget(
                                  providersModel: state.providers[i],
                                  canMakeAppointment: null,
                                  moreInfoButton: true,
                                  showFavoriteButton: false,
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                        ],
                      )
                    ],
                  ),
                );
              }
            case BaseState.error:
              return ErrorLayout(
                errorModel: state.error,
                onRetry: () {
                  ProvidersParams params = ProvidersParams(service_id: widget.service.id ?? 0);
                  BlocProvider.of<ProvidersCubit>(context).getProviders(params);
                },
              );
          }
          return Container();
        },
      ),
    );
  }
}