import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weltweit/features/logic/country/country_cubit.dart';
import 'package:weltweit/generated/assets.dart';

class ContactAction extends StatefulWidget {
  const ContactAction({super.key});

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
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (whatsapp != null)
                _imageGestureDetector(
                    image: Assets.imagesIcWhats,
                    onTap: () {
                      openWhatsApp(whatsapp);
                    }),
              if (facebook != null)
                _imageGestureDetector(
                    image: Assets.imagesIcFacebook,
                    onTap: () {
                      final Uri facebookLaunchUri = Uri(scheme: 'https', path: '$facebook');
                      launchUrl(facebookLaunchUri);
                    }),
              if (twitter != null)
                _imageGestureDetector(
                    image: Assets.imagesIcTwitter,
                    onTap: () {
                      final Uri twitterLaunchUri = Uri(scheme: 'https', path: twitter);
                      launchUrl(twitterLaunchUri);
                    }),
              _imageGestureDetector(
                  image: Assets.imagesIcCall,
                  onTap: () {
                    final Uri instagramLaunchUri = Uri(
                      scheme: 'tel',
                      path: '+201000000000',
                    );
                    launchUrl(instagramLaunchUri);
                  }),
              // _imageGestureDetector(image: Assets.imagesIcCall, onTap: () {
              //   final Uri instagramLaunchUri = Uri(
              //     scheme: 'https',
              //     path: 'www.instagram.com',
              //   );
              //   launchUrl(instagramLaunchUri);
              // }),
            ],
          );
        }
        if (state.countryModel == null) {
          return Center(child: Text('debug countryModel is null }'));
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

  openWhatsApp(String whatsAppnumber) async {
    bool status = await canLaunch('https://api.whatsapp.com/send?phone=$whatsAppnumber');
    if (status)
      launch('https://api.whatsapp.com/send?phone=$whatsAppnumber');
    else {
      bool status2 = await canLaunch('https://wsend.co/$whatsAppnumber');

      if (status2) launch('https://wsend.co/$whatsAppnumber');
    }
  }
}
