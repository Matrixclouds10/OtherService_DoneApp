
import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class ServiceProvidersPage extends StatelessWidget {
  final String service;
  const ServiceProvidersPage({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(service).header(),
        isCenterTitle: true,
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            ListAnimator(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: 12),
                for (var i = 0; i < 6; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesProvider.providerProvider, arguments: {
                        "provderName": 'مسعد معوض',
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
                      child: ServiceProviderItemWidget(
                        providersModel: ProvidersModel(
                          name: 'مسعد معوض',
                          distance: "6.2 كم",
                        ),
                        canMakeAppointment: null,
                        moreInfoButton: true,
                        showFavoriteButton: false,
                      ),
                    ),
                  ),
                SizedBox(height: 30),
              ],
            )
          ],
        ),
      ),
    );
  }
}
