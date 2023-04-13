import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/features/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/generated/assets.dart';

import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class ServiceProviderPage extends StatefulWidget {
  final String provderName;
  const ServiceProviderPage({required this.provderName, super.key});

  @override
  State<ServiceProviderPage> createState() => _ServiceProviderPageState();
}

class _ServiceProviderPageState extends State<ServiceProviderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(widget.provderName).header(),
        isCenterTitle: true,
        actions: [
          //chat
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 4),
            iconSize: 22,
            constraints: BoxConstraints(),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
          //rate
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 4),
            iconSize: 22,
            constraints: BoxConstraints(),
            icon: Icon(Icons.star),
            onPressed: () {},
          ),
          //more
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 4),
            iconSize: 22,
            constraints: BoxConstraints(),
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
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
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white),
                  child: ServiceProviderItemWidget(
                    providersModel: ProvidersModel(
                      name: 'مسعد معوض',
                      distance: "6.2 كم",
                    ),
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
                      singleTab(0, "خدماتي"),
                      singleTab(1, 'معرض الصور'),
                      singleTab(2, "التقييمات"),
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
    return Column(
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("صيانة السباكة", pv: 2).header(),
                CustomText("هذا النص عباره عن وصف توضيحي للخدمة وما تحتويه من تفاصيل تساعد العميل في تحديد احتياجه لها.", align: TextAlign.start, color: Colors.grey[500]!, pv: 2),
              ],
            ),
          ),
      ],
    );
  }

  gallery() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: [
              for (var i = 0; i < 6; i++) Container(margin: EdgeInsets.all(4), child: Image.asset("assets/images/ser_temp.png", fit: BoxFit.fill)),
            ],
          ),
        )
      ],
    );
  }

  reviews() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(width: 12),
              CustomText("3.4", size: 28),
              SizedBox(width: 12),
              Column(
                children: [
                  ratesAsStars(3),
                  Row(
                    children: [
                      CustomText("256", color: Colors.grey[500]!),
                      SizedBox(width: 4),
                      Icon(Icons.person, color: Colors.grey[500]!, size: 14),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: const [
                    LinearProgressIndicator(value: 0.9, color: Colors.greenAccent),
                    SizedBox(height: 2),
                    LinearProgressIndicator(value: 0.6, color: Colors.green),
                    SizedBox(height: 2),
                    LinearProgressIndicator(value: 0.7, color: Colors.orangeAccent),
                    SizedBox(height: 2),
                    LinearProgressIndicator(value: 0.4, color: Colors.orange),
                    SizedBox(height: 2),
                    LinearProgressIndicator(value: 0.1, color: Colors.red),
                  ],
                ),
              ),
              SizedBox(width: 12),
            ],
          ),
        ),
        for (var i = 0; i < 4; i++)
          Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8),
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText("مسعد معوض", pv: 2),
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
        for (var i = 0; i < d; i++) Icon(Icons.star, size: 12, color: Colors.yellow),
        for (var i = 0; i < 5 - d; i++) Icon(Icons.star, size: 12, color: Colors.grey),
      ],
    );
  }
}
