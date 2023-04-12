import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/services/core/routing/routes.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/presentation/component/component.dart';

class ServiceProviderItemWidget extends StatelessWidget {
  final ProvidersModel providersModel;
  final bool? canMakeAppointment;
  final bool? moreInfoButton;
  final bool showFavoriteButton;

  const ServiceProviderItemWidget({
    required this.providersModel,
    this.canMakeAppointment,
    this.moreInfoButton,
    required this.showFavoriteButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: CustomImage(
                  imageUrl: providersModel.image,
                  width: MediaQuery.of(context).size.width / 7,
                  height: MediaQuery.of(context).size.width / 7,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(providersModel.name ?? "N/A", color: Colors.black, align: TextAlign.start, pv: 0),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (canMakeAppointment != null && canMakeAppointment!)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, RoutesServices.servicesReservationPage, arguments: {
                                    "providersModel": providersModel,
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(color: servicesTheme.colorScheme.secondary).radius(radius: 4),
                                  child: const CustomText(
                                    "حجز موعد",
                                    color: Colors.white,
                                    pv: 6,
                                  ),
                                ),
                              ),
                            if (providersModel.rateAvg != null && canMakeAppointment == null) ratesAsStars(double.parse(providersModel.rateAvg!)),
                            if (showFavoriteButton)
                              IconButton(
                                icon: Icon(
                                  providersModel.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: providersModel.isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                          ],
                        )
                      ],
                    ),
                    if (providersModel.services != null)
                      Wrap(
                        children: [
                          ...providersModel.services!
                              .map((e) => CustomText(
                                    e.title ?? "N/A",
                                    color: Colors.grey,
                                    align: TextAlign.start,
                                    pv: 0,
                                    ph: 4,
                                  ).footerExtra())
                              .toList(),
                        ],
                      ),
                    // CustomText('no profession', color: Colors.grey, align: TextAlign.start, pv: 0),
                    // if (description != null)
                    CustomText('description', maxLines: 2, color: Colors.grey, align: TextAlign.start, pv: 4).footer(),
                    // if (address != null)
                    textWithIcon(
                      icon: Icons.location_on,
                      text: 'no address',
                    ),
                    Row(
                      children: [
                        if (providersModel.distance != null)
                          textWithIcon(
                            icon: Icons.route,
                            text: '${providersModel.distance!}',
                          ),
                        if (providersModel.isOnline)
                          Container(
                            decoration: const BoxDecoration(color: Color(0xff00A35E)).radius(radius: 4),
                            child: const CustomText(
                              "غير متوفر",
                              color: Colors.white,
                              pv: 2,
                              ph: 8,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          if (moreInfoButton != null && moreInfoButton!)
            Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(color: servicesTheme.colorScheme.secondary).radius(radius: 45),
              child: const CustomText(
                "المزيد من المعلومات",
                color: Colors.white,
                pv: 6,
                ph: 40,
              ),
            ),
        ],
      ),
    );
  }

  Widget ratesAsStars(double d) {
    return Row(
      children: [
        for (var i = 0; i < d; i++) const Icon(Icons.star, size: 12, color: Colors.yellow),
        for (var i = 0; i < 5 - d; i++) const Icon(Icons.star, size: 12, color: Colors.grey),
        CustomText(' ($d)', color: Colors.grey, align: TextAlign.start, pv: 0).footer(),
      ],
    );
  }

  Widget textWithIcon({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        CustomText(text, color: Colors.grey, align: TextAlign.start, pv: 0),
      ],
    );
  }
}
