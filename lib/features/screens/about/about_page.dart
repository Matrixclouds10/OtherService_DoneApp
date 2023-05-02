import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/logic/about/about_cubit.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import 'package:weltweit/presentation/component/component.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    context.read<AboutCubit>().getAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.aboutUs.tr()).header(),
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListAnimator(
          children: [
            const SizedBox(height: 12),
            Image.asset(Assets.imagesLogo, width: double.infinity, height: 90),
            const SizedBox(height: 12),
            BlocBuilder<AboutCubit, AboutState>(
              builder: (context, state) {
                switch (state.state) {
                  case BaseState.initial:
                  case BaseState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case BaseState.error:
                    return ErrorLayout(errorModel: state.error);
                  case BaseState.loaded:
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Colors.white).radius(radius: 12),
                            child: CustomText(state.data),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            
                              _imageGestureDetector(image: Assets.imagesIcWhats, onTap: () {
                                final Uri whatsappLaunchUri = Uri(
                                  scheme: 'https',
                                  path: 'wa.me/+201000000000',
                                );
                                launchUrl(whatsappLaunchUri);
                              }),
                              _imageGestureDetector(image: Assets.imagesIcFacebook, onTap: () {
                                final Uri facebookLaunchUri = Uri(
                                  scheme: 'https',
                                  path: 'www.facebook.com/DoneApplication?mibextid=LQQJ4d',
                                );
                                launchUrl(facebookLaunchUri);

                              }),
                              _imageGestureDetector(image: Assets.imagesIcTwitter, onTap: () {
                                final Uri twitterLaunchUri = Uri(
                                  scheme: 'https',
                                  path: 'twitter.com/doneapplication',
                                );
                                launchUrl(twitterLaunchUri);
                              }),
                              _imageGestureDetector(image: Assets.imagesIcCall, onTap: () {
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
                          )
                        ],
                      ),
                    );
                }
              },
            )
          ],
        ),
      ),
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
}
