import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/country/country_cubit.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class ContactAction extends StatefulWidget {
  final bool showDivider;
  const ContactAction({super.key, required this.showDivider});

  @override
  State<ContactAction> createState() => _ContactActionState();
}

class _ContactActionState extends State<ContactAction> {
  @override
  void initState() {
    super.initState();
    context.read<CountryCubit>().getCountry();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCubit, CountryState>(
      builder: (context, state) {
        if (state.countryModel != null) {
          String? facebook = state.countryModel!.facebook;
          String? twitter = state.countryModel!.twitter;
          String? whatsapp = state.countryModel!.whatsapp;
          String? taam = state.countryModel!.taam;
          return Column(
            children: [
              if (widget.showDivider && facebook != null && whatsapp != null && twitter != null) ...[
                Stack(
                  children: [
                    const Divider(height: 40),
                    Positioned(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          color: servicesTheme.scaffoldBackgroundColor,
                          child: CustomText(LocaleKeys.or.tr()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (whatsapp != null)
                    _imageGestureDetector(
                        image: Assets.imagesIcWhats,
                        onTap: () {
                          openWhatsApp(whatsapp, state.countryModel?.code ?? "");
                        }),
                  if (facebook != null)
                    _imageGestureDetector(
                        image: Assets.imagesIcFacebook,
                        onTap: () {
                          String url = facebook.replaceAll('https://', '');
                          final Uri facebookLaunchUri = Uri(path: url, scheme: 'https');
                          launchUrl(facebookLaunchUri);
                        }),
                  if (twitter != null)
                    _imageGestureDetector(
                        image: Assets.imagesIcTwitter,
                        onTap: () {
                          launch(twitter);
                        }),
                  // _imageGestureDetector(
                  //     image: Assets.imagesIcCall,
                  //     onTap: () {
                  //       final Uri instagramLaunchUri = Uri(
                  //         scheme: 'tel',
                  //         path: '+201000000000',
                  //       );
                  //       launchUrl(instagramLaunchUri);
                  //     }),
                  // _imageGestureDetector(image: Assets.imagesIcCall, onTap: () {
                  //   final Uri instagramLaunchUri = Uri(
                  //     scheme: 'https',
                  //     path: 'www.instagram.com',
                  //   );
                  //   launchUrl(instagramLaunchUri);
                  // }),
                ],
              ),
            ],
          );
        }
       
        return Container();
      },
    );
  }

  _imageGestureDetector({required String image, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(image, width: 70, height: 70),
      ),
    );
  }

  openWhatsApp(String whatsAppnumber, String countryCode) async {
    bool status = await canLaunch('https://api.whatsapp.com/send?phone=$countryCode$whatsAppnumber');
    if (status)
      launch('https://api.whatsapp.com/send?phone=$countryCode$whatsAppnumber');
    else {
      bool status2 = await canLaunch('https://wsend.co/$countryCode$whatsAppnumber');

      if (status2) launch('https://wsend.co/$countryCode$whatsAppnumber');
    }
  }
}
