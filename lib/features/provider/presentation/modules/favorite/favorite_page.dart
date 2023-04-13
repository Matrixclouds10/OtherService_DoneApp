import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weltweit/features/core/widgets/offer_item_widget.dart';
import 'package:weltweit/features/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/generated/assets.dart';

import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

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
        titleWidget: CustomText("المفضلة").header(),
        isCenterTitle: true,
        isBackButtonExist: false,
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListAnimator(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: 0),
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
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffE67E23) : Colors.white,
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
    return Column(
      children: [
        SizedBox(height: 12),
        for (var i = 0; i < 6; i++)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RoutesServices.servicesProvider, arguments: {
                "provderName": 'مسعد معوض',
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
              child: ServiceProviderItemWidget(
                providersModel: ProvidersModel(
                  name: 'مسعد معوض',
                  distance: "6.2 كم",
                ),

                canMakeAppointment: null, showFavoriteButton: false,
              ),
            ),
          ),
        SizedBox(height: 20),
      ],
    );
  }

  offers() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < 4; i++)
            OfferItemWidget(
              imageUrl: "assets/images/offer_image.png",
              title: "عرض الصيف",
              description: "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة",
              isFavorite: true,
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
