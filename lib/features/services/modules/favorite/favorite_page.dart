import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/services/core/base/base_states.dart';
import 'package:weltweit/features/services/core/routing/routes.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/core/widgets/offer_item_widget.dart';
import 'package:weltweit/features/services/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/logic/favorite/favorite_cubit.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: const CustomText("المفضلة").header(),
        isCenterTitle: true,
        isBackButtonExist: false,
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
                      singleTab(0, "مزودي الخدمة"),
                      singleTab(1, 'العروض'),
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
        return providers();
      case 1:
        return offers();
      default:
        return Container();
    }
  }

  providers() {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        if (state.state == BaseState.loading) return const Center(child: CustomLoadingSpinner());

        return Column(
          children: [
            const SizedBox(height: 12),
            for (var i = 0; i < state.data.length; i++)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesServices.servicesProvider, arguments: {
                    "provider": state.data[i],
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: const BoxDecoration(color: Colors.white).radius(radius: 12),
                  child: ServiceProviderItemWidget(
                    providersModel: state.data[i],
                    canMakeAppointment: null,
                    showFavoriteButton: true,
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  offers() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < 4; i++)
            const OfferItemWidget(
              imageUrl: Assets.imagesOfferImage,
              title: "عرض الصيف",
              description: "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة",
              isFavorite: true,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
