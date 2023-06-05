import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/features/data/models/banner/banner_model.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/presentation/component/component.dart';

class HomeBanner extends StatefulWidget {
  final List<BannerModel> banners;
  const HomeBanner({required this.banners, super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int currentSliderPosition = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: widget.banners.map((singleSlider) {
              return Container(
                margin: EdgeInsets.only(bottom: 2),
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: singleSlider.image ?? '',
                    errorWidget: (vtx, url, obj) {
                      return Center(child: Image.asset(Assets.imagesLogo));
                    },
                    placeholder: (ctx, url) {
                      return CustomLoadingSpinner();
                    },
                    fit: BoxFit.fill,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              aspectRatio: 1.65,
              viewportFraction: 1.0,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayAnimationDuration: Duration(milliseconds: 650),
              enlargeCenterPage: false,
              disableCenter: false,
              scrollDirection: Axis.horizontal,
              // to see it like cards
              initialPage: currentSliderPosition,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: widget.banners.isNotEmpty ? true : false,
              height: deviceHeight / 4,
              onPageChanged: (pageNo, reason) {
                currentSliderPosition = pageNo;
                setState(() {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ...widget.banners.map((singleString) {
                var index = widget.banners.indexOf(singleString);
                return Container(
                    width: currentSliderPosition == index ? 24.0 : 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration:
                        BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(80), color: currentSliderPosition == index ? AppColorLight().kPrimaryColor : Color(0xffE1E1E1)));
              }),
            ],
          ),
        ],
      ),
    );
  }
}
