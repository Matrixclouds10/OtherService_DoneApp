import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/services/core/base/base_states.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/features/services/logic/provider/provider_portfolio/provider_portfolio_cubit.dart';
import 'package:weltweit/features/services/widgets/app_dialogs.dart';
import 'package:weltweit/features/services/widgets/app_snackbar.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class ServiceProviderPage extends StatefulWidget {
  final ProvidersModel provider;
  const ServiceProviderPage({required this.provider, super.key});

  @override
  State<ServiceProviderPage> createState() => _ServiceProviderPageState();
}

class _ServiceProviderPageState extends State<ServiceProviderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isFavorite = widget.provider.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(widget.provider.name ?? '').header(),
        isCenterTitle: true,
        actions: [
          //chat
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            iconSize: 22,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {},
          ),
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

          //more
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            iconSize: 22,
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListAnimator(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
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
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const CustomText("3.4", size: 28),
              const SizedBox(width: 12),
              Column(
                children: [
                  ratesAsStars(3),
                  Row(
                    children: [
                      CustomText("256", color: Colors.grey[500]!),
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
                    const LinearProgressIndicator(value: 0.9, color: Colors.greenAccent),
                    const SizedBox(height: 2),
                    const LinearProgressIndicator(value: 0.6, color: Colors.green),
                    const SizedBox(height: 2),
                    LinearProgressIndicator(value: 0.7, color: servicesTheme.primaryColor),
                    const SizedBox(height: 2),
                    LinearProgressIndicator(value: 0.4, color: servicesTheme.primaryColor),
                    const SizedBox(height: 2),
                    const LinearProgressIndicator(value: 0.1, color: Colors.red),
                  ],
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        for (var i = 0; i < 4; i++)
          Container(
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
                        const CustomText("مسعد معوض", pv: 2),
                        ratesAsStars(Random().nextInt(4) + 1),
                        CustomText("إنه سباك محترف وقام بجميع الأعمال المتعلقة بالسباكة في منزلنا. انا اوصي بشده به", align: TextAlign.start, color: Colors.grey[500]!, pv: 0).footer(),
                      ],
                    ),
                  ),
                ],
              )),
      ],
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
