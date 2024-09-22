import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/presentation/component/component.dart';

import '../../../generated/locale_keys.g.dart';
import '../../data/models/provider/providers_model.dart';
import '../../widgets/app_dialogs.dart';

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
        onTap: () async{
          bool isOk = await  AppDialogs().question(context, message: '${LocaleKeys.areSureToSubscribe.tr()}\n\n${serviceModel.title}');
          if(isOk){
             ProvidersModel providersModel=ProvidersModel(name: serviceModel.title,
                 distance:0, id: serviceModel.id, image: serviceModel.image, services: [serviceModel],);
            Navigator.pushNamed(context, RoutesServices.servicesReservationPage, arguments: {
              "providersModel": providersModel,
            });
          }
          // Navigator.pushNamed(context, RoutesServices.servicesProviders, arguments: {
          //   "service": serviceModel,
          // });
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImage(
                imageUrl: serviceModel.image ?? '',
                width: width,
                height: height ?? width,
                fit: BoxFit.fill,
              ),
            )
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
        onTap: () async{
          bool isOk = await  AppDialogs().question(context, message: '${LocaleKeys.areSureToSubscribe.tr()}\n\n${serviceModel.title}');
          if(isOk){
            ProvidersModel providersModel=ProvidersModel(name: serviceModel.title,
              distance:0, id: serviceModel.id, image: serviceModel.image, services: [serviceModel],);

            Navigator.pushNamed(context, RoutesServices.servicesReservationPage, arguments: {
              "providersModel": providersModel,
            });
          }
          // Navigator.pushNamed(context, RoutesServices.servicesProviders, arguments: {
          //   "service": serviceModel,
          // });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const SizedBox(width: 12),
            Icon(Icons.home_repair_service, color: Colors.grey, size: 30),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(250),
              //   child: CustomImage(
              //     imageUrl: serviceModel.image,
              //     width: width,
              //     height: height ?? width,
              //     fit: BoxFit.fill,
              //   ),
              // ),
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
