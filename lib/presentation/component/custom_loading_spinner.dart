import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

import 'base_platform_widget.dart';

class CustomLoadingSpinner extends BasePlatformWidget<Center, Center> {
  final Color? color;
  final double? size;
  const CustomLoadingSpinner({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);
  @override
  Center createCupertinoWidget(BuildContext context) {
    return Center(
        child: SpinKitFadingFour(
            color: color ?? Theme.of(context).primaryColor, size: 35));
    // return Center(child: CupertinoActivityIndicator(radius: 24.r));
  }

  @override
  Center createMaterialWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        height: (size ?? 24).r,
        width: (size ?? 24).r,
        child: SpinKitDoubleBounce(
          color: color ?? Theme.of(context).primaryColor,
          size: 35,
        ),
        // child:  CircularProgressIndicator(strokeWidth: 3.w,color: color,),
      ),
    );
  }
}
