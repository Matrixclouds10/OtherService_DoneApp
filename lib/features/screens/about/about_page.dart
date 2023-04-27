import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/generated/assets.dart';

import 'package:weltweit/presentation/component/component.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: const CustomText("من نحن").header(),
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListAnimator(
          children: [
            //Log
            Image.asset(
              Assets.imagesLogo,
              width: double.infinity,
              height: 120,
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white)
                        .radius(radius: 12),
                    child: const CustomText(
                        "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى. يمكنك أيضاً إدخال نص. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى. يمكنك أيضاً إدخال نص. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى. يمكنك أيضاً إدخال نص. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(Assets.imagesIcCall,
                          width: 70, height: 70),
                      Image.asset(Assets.imagesIcWhats,
                          width: 70, height: 70),
                      Image.asset(Assets.imagesIcFacebook,
                          width: 70, height: 70),
                      Image.asset(Assets.imagesIcTwitter,
                          width: 70, height: 70),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
