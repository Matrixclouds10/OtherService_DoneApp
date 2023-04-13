import 'package:flutter/material.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import 'package:weltweit/presentation/component/component.dart';

class ServiceItemWidget extends StatelessWidget {
  final double width;
  final double? height;
  final ServiceModel serviceModel;
  final bool grid;
  const ServiceItemWidget({
    required this.width,
    required this.grid,
    required this.serviceModel,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (grid) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesServices.servicesProviders, arguments: {
            "service": serviceModel,
          });
        },
        child: Stack(
          children: [
            CustomImage(
              imageUrl: serviceModel.image ?? '',
              width: width,
              height: height ?? width,
              fit: BoxFit.fill,
            ),
            // Positioned(
            //   bottom: 4,
            //   left: 4,
            //   right: 4,
            //   child: CustomText(serviceModel.title ?? '', color: Colors.white, maxLines: 1).footerExtra(),
            // ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesServices.servicesProviders, arguments: {
            "service": serviceModel,
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: CustomImage(
                  imageUrl: serviceModel.image,
                  width: width,
                  height: height ?? width,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(serviceModel.title ?? 'N/A', color: Colors.black, align: TextAlign.start, pv: 0).header().start(),
                    if (serviceModel.breif != null) CustomText(serviceModel.breif!, color: Colors.black, align: TextAlign.start, pv: 0).footer().start(),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
            ],
          ),
        ),
      );
    }
  }
}
