import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/data/models/portfolio/portfolio_image.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolio_update_usecase.dart';
import 'package:weltweit/features/logic/provider/provider/provider_cubit.dart';
import 'package:weltweit/features/logic/provider_portfolio/portfolio_cubit.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/logic/provider_service/services_cubit.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<ServicesProviderCubit>().getAllServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        isBackButtonExist: false,
        isCenterTitle: true,
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.myProfile.tr()).header(),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note, color: Colors.black),
            onPressed: () {
              NavigationService.push(RoutesProvider.providerProfileUpdateScreen);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListAnimator(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: 0),
                BlocBuilder<ProfileProviderCubit, ProfileProviderState>(
                  builder: (context, state) {
                    UserModel? user = state.data;
                    if (user == null) return Container();
                    return Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white),
                      child: ServiceProviderItemWidget(
                        providersModel: ProvidersModel(
                          name: state.data?.name,
                          description: state.data?.desc,
                          image: state.data?.image,
                          mobileNumber: state.data?.mobileNumber,
                          email: state.data?.email,
                          isOnline: state.data?.isOnline?.toLowerCase() == "yes",
                        ),
                        userModel: user,
                        canMakeAppointment: null,
                        moreInfoButton: false,
                        showFavoriteButton: false,
                      ),
                    );
                  },
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
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffE67E23) : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomText(title, color: isSelected ? Colors.white : Colors.black).footer(),
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
    return BlocBuilder<ServicesProviderCubit, ServicesProviderState>(
            buildWhen: (previous, current) => previous.myServices != current.myServices,
            builder: (context, state) {
              print("------> state.updateState ${state.updateState}");
              if (state.state == BaseState.loaded){
                return
                  Column(
                    children: [
                      if( state.myServices.isEmpty)
                        InkWell(
                          onTap: () => NavigationService.push(RoutesProvider.providerServices),
                          child: Row(
                            children: [
                              SizedBox(width: 24),
                              Icon(FontAwesomeIcons.plusCircle,
                                  size: 30, color: primaryColor),
                              SizedBox(width: 12),
                              CustomText(LocaleKeys.addNewService.tr(), pv: 0),
                              Spacer(),
                            ],
                          ),
                        )
                      else
                        InkWell(
                          onTap: () => NavigationService.push(RoutesProvider.providerServices),
                          child: Row(
                            children: [
                              SizedBox(width: 24),
                              Icon(FontAwesomeIcons.upload,
                                  size: 30, color: primaryColor),
                              SizedBox(width: 12),
                              CustomText(LocaleKeys.updateNewService.tr(), pv: 0),
                              Spacer(),
                            ],
                          ),
                        ),
                      SizedBox(height: 8),
                      for (var i = 0; i < state.myServices.length; i++)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(state.myServices[i].title ?? "", pv: 2).header(),
                              if (state.myServices[i].breif != null) CustomText(state.myServices[i].breif!, align: TextAlign.start, color: Colors.grey[500]!, pv: 2),
                            ],
                          ),
                        ),
                    ],
                  );
              }else{
                return CustomLoadingSpinner();

              }

            },
          );

  }

  gallery() {
    return BlocConsumer<PortfoliosCubit, PortfoliosState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        if (state.message != null) {
          AppSnackbar.show(context: context, message: state.message!);
        }
      },
      bloc: BlocProvider.of<PortfoliosCubit>(context)..getPortfolios(),
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                if (state.addState == BaseState.loading)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CustomLoadingSpinner(),
                  ),
                if (state.addState != BaseState.loading)
                  GestureDetector(
                    onTap: () async {
                      if (state.addState == BaseState.loading) return;
                      File? file;
                      file = await AppDialogs().pickImage(context);
                      if (file == null) return;
                      if (context.mounted) BlocProvider.of<PortfoliosCubit>(context).addPortfolio(file);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: AppTextTile(
                        title: CustomText(tr(LocaleKeys.addImage), pv: 0),
                        leading: Icon(FontAwesomeIcons.circlePlus, size: 24, color: primaryColor),
                      ),
                    ),
                  ),
                Spacer(),
              ],
            ),
            SizedBox(height: 8),
            if (state.state == BaseState.loaded) imagesView(state.data),
            if (state.state == BaseState.loading) Center(child: CustomLoadingSpinner()),
            if (state.state == BaseState.error) Center(child: ErrorLayout(errorModel: state.error)),
          ],
        );
      },
    );
  }

  imagesView(List<PortfolioModel>? data) {
    if (data == null) return Container();
    if (data.isEmpty) return Container();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.4,
        children: [
          for (var i = 0; i < data.length; i++)
            GestureDetector(
              onTap: () async {
                List<Widget> list = [
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (context.mounted) {
                        BlocProvider.of<PortfoliosCubit>(context).delete(data[i]);
                      }
                    },
                    icon: Icon(FontAwesomeIcons.trashCan, color: Colors.red),
                    label: CustomText(LocaleKeys.delete, color: Colors.red).header(),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      File? file;
                      file = await AppDialogs().pickImage(context);
                      if (file == null) return;
                      PortfolioParams params = PortfolioParams(id: data[i].id!, image: file);
                      if (context.mounted) {
                        BlocProvider.of<PortfoliosCubit>(context).updatePortfolio(params);
                      }
                    },
                    icon: Icon(FontAwesomeIcons.penToSquare, color: Colors.blue),
                    label: CustomText(LocaleKeys.update, color: Colors.blue).header(),
                  ),
                  SizedBox(height: 12)
                ];
                await AppDialogs().selectWidget(
                  context: context,
                  list: list,
                  message: LocaleKeys.selectAction.tr(),
                );
              },
              child: Container(
                margin: EdgeInsets.all(4),
                child: CustomImage(
                  imageUrl: data[i].image,
                ),
              ),
            )
          //
        ],
      ),
    );
  }

  reviews() {
    ProfileProviderCubit profileProviderCubit = BlocProvider.of<ProfileProviderCubit>(context);
    if(profileProviderCubit.state.data == null) return Container();
    ProviderCubit providerCubit = BlocProvider.of<ProviderCubit>(context);
    providerCubit.getRates(profileProviderCubit.state.data?.id ?? 0);
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {
        if (state.rateState == BaseState.loading) {
          return Container(padding: EdgeInsets.symmetric(horizontal: 8), child: CustomLoadingSpinner());
        }

        if (state.rateState == BaseState.error) {
          return ErrorView(
            message: LocaleKeys.somethingWentWrong.tr(),
            onRetry: () {
              context.read<ProviderCubit>().getRates(profileProviderCubit.state.data?.id ?? 0);
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
                  CustomText(double.parse(providerCubit.state.data?.rateAvg ?? '0').toString(), size: 28),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      ratesAsStars(double.parse(providerCubit.state.data?.rateAvg ?? '0')),
                      Row(
                        children: [
                          CustomText("${providerCubit.state.data?.rateCount ?? 0}", color: Colors.grey[500]!),
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
        for (var i = 0; i < d; i++) Icon(FontAwesomeIcons.star, size: 12, color: Colors.yellow),
        for (var i = 0; i < 5 - d; i++) Icon(FontAwesomeIcons.star, size: 12, color: Colors.grey),
      ],
    );
  }
}
