import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/core/resources/decoration.dart';

import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/presentation/component/component.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText("من نحن").header(),
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListAnimator(
          children: [
            //Log
            Image.asset(
              "assets/images/placeholder.jpg",
              width: double.infinity,
              fit: BoxFit.cover,
              height: 120,
            ),
            SizedBox(height: 12),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.white).radius(radius: 12),
                    child: CustomText(
                        "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى. يمكنك أيضاً إدخال نص. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى. يمكنك أيضاً إدخال نص. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى. يمكنك أيضاً إدخال نص. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك إنشاء مثل هذا النص أو العديد من النصوص الأخرى"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("assets/images/ic_call.png",
                          width: 70, height: 70),
                      Image.asset("assets/images/ic_whats.png",
                          width: 70, height: 70),
                      Image.asset("assets/images/ic_facebook.png",
                          width: 70, height: 70),
                      Image.asset("assets/images/ic_twitter.png",
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
