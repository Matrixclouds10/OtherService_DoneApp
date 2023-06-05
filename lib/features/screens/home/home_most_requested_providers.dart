import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/provider/providers_cubit.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/images/custom_image.dart';

class MostRequestedProviders extends StatelessWidget {
  const MostRequestedProviders({super.key});

  @override
  Widget build(BuildContext context) {
    Locale locale = EasyLocalization.of(context)!.locale;
    return FutureBuilder(
      future: context.read<ProvidersCubit>().getMostRequestedProviders(),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
        String servicesAsString = snapshot.data![0].services?.map((e) => e.title).join(', ') ?? '';
        return snapshot.hasData
            ? Column(
                children: [
                  Row(
                    children: [
                      CustomText(LocaleKeys.most_requested_providers.tr(), color: Colors.black54).footer(),
                    ],
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesServices.servicesProvider, arguments: {
                            "provider": snapshot.data![index],
                          });
                        },
                        child: Container(
                          width: deviceWidth * 0.6,
                          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                AvatarImage(
                                  size: 26,
                                  shape: AvatarImageShape.circle,
                                  child: CustomImage(
                                    imageUrl: snapshot.data![index].image,
                                    radius: 250,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        snapshot.data![index].name ?? '',
                                        color: Colors.black,
                                        align: TextAlign.start,
                                        pv: 0,
                                      ).footer(),
                                      CustomText(
                                        servicesAsString,
                                        color: Colors.grey,
                                        align: TextAlign.start,
                                        pv: 0,
                                      ).footerExtra(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
