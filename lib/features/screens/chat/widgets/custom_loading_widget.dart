import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/resources/color.dart';

class CustomLoadingWidget extends StatelessWidget {
  final Color? color;
  const CustomLoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return   SpinKitCircle(
      color:color?? primaryColor,
      size: 50.0,
    );
  }
}
