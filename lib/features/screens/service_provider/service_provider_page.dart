import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/features/logic/provider/provider/provider_cubit.dart';
import 'package:weltweit/features/logic/provider/provider_portfolio/provider_portfolio_cubit.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class ServiceProviderPage extends StatefulWidget {
  final ProvidersModel provider;
  const ServiceProviderPage({required this.provider, super.key});
//حجز موعد
  @override
  State<ServiceProviderPage> createState() => _ServiceProviderPageState();
}

class _ServiceProviderPageState extends State<ServiceProviderPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderCubit>().getProvider(widget.provider.id!);
    context.read<ProviderCubit>().getRates(widget.provider.id!);
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {
        Widget body = Container();
        switch (state.state) {
          case BaseState.initial:
          case BaseState.loading:
            body = CustomLoadingSpinner();
            break;
          case BaseState.loaded:
            return ServiceProviderView(provider: state.data!);
          case BaseState.error:
            body = ErrorLayout(
              errorModel: state.error,
              onRetry: () {
                context.read<ProviderCubit>().getProvider(widget.provider.id!);
              },
            );
            break;
        }
        return Scaffold(
          appBar: CustomAppBar(
            color: Colors.white,
            titleWidget: CustomText(widget.provider.name ?? '').header(),
            isCenterTitle: true,
          ),
          body: body,
        );
      },
    );
  }
}

class ServiceProviderView extends StatefulWidget {
  final ProvidersModel provider;
  const ServiceProviderView({required this.provider, super.key});

  @override
  State<ServiceProviderView> createState() => _ServiceProviderViewState();
}

class _ServiceProviderViewState extends State<ServiceProviderView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isFavorite = widget.provider.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            color: Colors.white,
            titleWidget: CustomText(widget.provider.name ?? '').header(),
            isCenterTitle: true,
            actions: [
              // //chat
              // IconButton(
              //   padding: const EdgeInsets.symmetric(horizontal: 4),
              //   iconSize: 22,
              //   constraints: const BoxConstraints(),
              //   visualDensity: VisualDensity.compact,
              //   style: ButtonStyle(
              //     padding: MaterialStateProperty.all(EdgeInsets.zero),
              //   ),
              //   icon: const Icon(Icons.chat_bubble_outline_rounded),
              //   onPressed: () {},
              // ),

              //rate
              BlocConsumer<FavoriteCubit, FavoriteState>(
                buildWhen: (previous, current) => previous.addState != current.addState,
                listener: (context, state) {
                  if (state.addState == BaseState.error) {
                    AppSnackbar.show(context: context, message: LocaleKeys.somethingWentWrong.tr());
                  }

                  // if (state.addState == BaseState.loaded) {
                  //   AppSnackbar.show(context: context, message: LocaleKeys.addedToFavorite.tr());
                  // }
                },
                builder: (context, state) {
                  if (state.addState == BaseState.loading) {
                    return Container(padding: EdgeInsets.symmetric(horizontal: 8), child: CustomLoadingSpinner());
                  }
                  return IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    iconSize: 22,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_outline_rounded,
                      color: isFavorite ? Colors.yellow[700] : Colors.black,
                    ),
                    onPressed: () async {
                      if (widget.provider.id != null) {
                        await context.read<FavoriteCubit>().addFavorite(widget.provider.id!);
                        isFavorite = !isFavorite;
                      }
                    },
                  );
                },
              ),
            ],
          ),
          backgroundColor: servicesTheme.scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 0),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ServiceProviderItemWidget(
                    providersModel: widget.provider,
                    canMakeAppointment: true,
                    showFavoriteButton: false,
                  ),
                ),
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
                      singleTab(0, LocaleKeys.myServices.tr()),
                      singleTab(1, LocaleKeys.gallery.tr()),
                      singleTab(2, LocaleKeys.rates.tr()),
                    ],
                  ),
                ),
                tabBody(),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
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
        child: FittedBox(fit: BoxFit.scaleDown, child: CustomText(title, color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  tabBody() {
    switch (_tabController.index) {
      case 0:
        return services();
      case 1:
        return gallery();
      case 2:
        return reviews();
      default:
        return Container();
    }
  }

  services() {
    int servicesCount = widget.provider.services?.length ?? 0;
    return Column(
      children: [
        for (var i = 0; i < servicesCount; i++)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(widget.provider.services![i].title ?? '', pv: 2).header(),
                CustomText(widget.provider.services![i].breif ?? '', align: TextAlign.start, color: Colors.grey[500]!, pv: 2),
              ],
            ),
          ),
      ],
    );
  }

  gallery() {
    return BlocProvider(
      create: (context) => ProviderPortfolioCubit(getIt())..getProviderPortfolio(widget.provider.id ?? 0),
      child: BlocBuilder<ProviderPortfolioCubit, ProviderPortfolioState>(
        builder: (context, state) {
          if (state.state == BaseState.loading) return const Center(child: CustomLoadingSpinner());
          if (state.state == BaseState.error) return const Center(child: Text('Error'));
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  children: [
                    for (var i = 0; i < state.data.length; i++)
                      GestureDetector(
                        onTap: () {
                          AppDialogs().showImageDialog(context, state.data[i].image ?? '');
                        },
                        child: Container(
                            margin: const EdgeInsets.all(4),
                            child: CustomImage(
                              imageUrl: state.data[i].image ?? '',
                              fit: BoxFit.fill,
                            )),
                      ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  reviews() {
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {
        if (state.rateState == BaseState.loading) {
          return Container(padding: EdgeInsets.symmetric(horizontal: 8), child: CustomLoadingSpinner());
        }

        if (state.rateState == BaseState.error) {
          return ErrorView(
            message: LocaleKeys.somethingWentWrong.tr(),
            onRetry: () {
              context.read<ProviderCubit>().getRates(widget.provider.id ?? 0);
            },
          );
        }

        int rate1StarCount = state.dataRates.where((element) => element.rate == 1).length;
        int rate2StarCount = state.dataRates.where((element) => element.rate == 2).length;
        int rate3StarCount = state.dataRates.where((element) => element.rate == 3).length;
        int rate4StarCount = state.dataRates.where((element) => element.rate == 4).length;
        int rate5StarCount = state.dataRates.where((element) => element.rate == 5).length;

        double rate1StarPercent = state.dataRates.isEmpty ? 0 : (rate1StarCount / state.dataRates.length);
        double rate2StarPercent = state.dataRates.isEmpty ? 0 : (rate2StarCount / state.dataRates.length);
        double rate3StarPercent = state.dataRates.isEmpty ? 0 : (rate3StarCount / state.dataRates.length);
        double rate4StarPercent = state.dataRates.isEmpty ? 0 : (rate4StarCount / state.dataRates.length);
        double rate5StarPercent = state.dataRates.isEmpty ? 0 : (rate5StarCount / state.dataRates.length);
        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  CustomText(double.parse(widget.provider.rateAvg ?? '0').toString(), size: 28),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      ratesAsStars(double.parse(widget.provider.rateAvg ?? '0')),
                      Row(
                        children: [
                          CustomText("${widget.provider.rateCount ?? 0}", color: Colors.grey[500]!),
                          const SizedBox(width: 4),
                          Icon(Icons.person, color: Colors.grey[500]!, size: 14),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        // CustomText(rate5StarPercent.toString()),
                        // const SizedBox(height: 2),
                        // CustomText(rate4StarPercent.toString()),
                        // const SizedBox(height: 2),
                        // CustomText(rate3StarPercent.toString()),
                        // const SizedBox(height: 2),
                        // CustomText(rate2StarPercent.toString()),
                        // const SizedBox(height: 2),
                        // CustomText(rate1StarPercent.toString()),
                        LinearProgressIndicator(value: rate5StarPercent, color: Colors.red),
                        const SizedBox(height: 2),
                        LinearProgressIndicator(value: rate4StarPercent, color: servicesTheme.primaryColor),
                        const SizedBox(height: 2),
                        LinearProgressIndicator(value: rate3StarPercent, color: servicesTheme.primaryColor.withOpacity(0.7)),
                        const SizedBox(height: 2),
                        LinearProgressIndicator(value: rate2StarPercent, color: Colors.green),
                        const SizedBox(height: 2),
                        LinearProgressIndicator(value: rate1StarPercent, color: Colors.greenAccent),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            ...state.dataRates
                .map(
                  (e) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: Image.asset(
                                Assets.imagesAvatar,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width / 7,
                                height: MediaQuery.of(context).size.width / 7,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(e.clientName ?? "N/A", pv: 2),
                                ratesAsStars(e.rate?.toDouble() ?? 5),
                                CustomText(e.comment ?? "No comment", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                              ],
                            ),
                          ),
                        ],
                      )),
                )
                .toList(),
          ],
        );
      },
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
}
