import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/logic/about/about_cubit.dart';
import 'package:weltweit/features/screens/about/contact_actions.dart';
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
                          ContactAction(showDivider: false),
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


}


