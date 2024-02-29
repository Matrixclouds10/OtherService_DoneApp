import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/decoration.dart';

import '../../../../generated/assets.dart';
import '../../../core/resources/values_manager.dart';
import '../../../core/utils/attach_image.dart';
import '../../../core/utils/validators.dart';

class CustomImage extends StatelessWidget {
  final double radius;
  final BorderRadius? borderRadius;
  final Border? border;

  final double? width;
  final double height;

  final String? imageUrl;
  final BoxFit? fit;

  final bool canEdit;
  final bool showPlaceholder;
  final Function(String path)? onAttachImage;

  const CustomImage({
    Key? key,
    this.radius = 16,
    this.borderRadius,
    this.border,
    this.fit = BoxFit.fill,
    this.canEdit = false,
    this.showPlaceholder = true,
    this.height = 140,
    this.onAttachImage,
    this.width,
    required this.imageUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget image = buildImage(context);
    return Stack(children: [
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius.r)),
        child: Container(
          decoration: const BoxDecoration().customRadius(borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius.r))),
          child: image,
        ),
      ),
      if (canEdit)
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            height: 32.r,
            width: 32.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              color: Theme.of(context).primaryColor,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  File? file = await onPickImagesPressed(context);

                  if (file != null && onAttachImage != null) {
                    onAttachImage!(file.path);
                  }
                },
                borderRadius: BorderRadius.circular(100),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
    ]);
  }

  Widget buildPlaceholder() {
    return showPlaceholder ? Image.asset(Assets.imagesPlaceholder, width: width ?? deviceWidth, height: height) : const SizedBox();
  }

  Widget buildImage(BuildContext context) {
    if (imageUrl == null) return buildPlaceholder();
    if (imageUrl!.isEmpty) return buildPlaceholder();
    if (imageUrl!.endsWith('.svg')) {
      return SvgPicture.network(imageUrl!, width: width ?? deviceWidth, height: height);
    }
    if (imageUrl!.contains('assets/') && imageUrl!.contains('images')) {
      return Image.asset(imageUrl!, width: width ?? deviceWidth, height: height);
    }
    if (Validators.isURL(imageUrl)) {
      return CachedNetworkImage(
        placeholder: (ctx, url) => buildPlaceholder(),
        width: width ?? deviceWidth,
        height: height,
        fit: fit,
        imageUrl: imageUrl!,
        errorWidget: (c, url, error) {
          return Container(
              width: width ?? deviceWidth,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius)),
              ).radius(radius: radius),
              child: Icon(Icons.error_outline, color: Colors.red));
        },
      );
    }

    return Image.file(File(imageUrl!), width: width ?? deviceWidth, height: height, fit: BoxFit.fill);
  }
}
