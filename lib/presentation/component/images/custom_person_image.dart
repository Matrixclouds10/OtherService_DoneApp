import 'dart:io';

import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';
import '../../../core/utils/attach_image.dart';
import '../../../core/utils/validators.dart';

class CustomPersonImage extends StatelessWidget {
  final String? _imageUrl;
  final String? _avatar;
  final double _borderSize;
  final double _size;
  final bool _canEdit;
  final bool _showShadow;
  final Function? _onEdit;
  final Function(File path)? _onAttachImage;

  const CustomPersonImage({
    super.key,
    String? imageUrl,
    String? avatar,
    double borderSize = 4,
    double size = 100,
    bool canEdit = false,
    bool showShadow = true,
    Function? onEdit,
    Function(File path)? onAttachImage,
  })  : _imageUrl = imageUrl,
        _avatar = avatar,
        _borderSize = borderSize,
        _size = size,
        _showShadow = showShadow,
        _canEdit = canEdit,
        _onEdit = onEdit,
        _onAttachImage = onAttachImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: _size.r,
            height: _size.r,
            decoration: BoxDecoration(
              border: Border.all(width: _borderSize, color: Theme.of(context).scaffoldBackgroundColor),
              boxShadow: _showShadow
                  ? [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 10),
                      )
                    ]
                  : null,
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: (_imageUrl ?? '').isEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        _avatar ?? Assets.imagesImgAvatarPlaceholder,
                        fit: BoxFit.cover,
                        width: _size.r,
                        height: _size.r,
                      ),
                    )
                  : !Validators.isURL(_imageUrl)
                      ? Image.file(File(_imageUrl!), width: _size.r, height: _size.r, fit: BoxFit.fill)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage.assetNetwork(
                            placeholder: _avatar ?? Assets.imagesImgAvatarPlaceholder,
                            width: _size.r,
                            height: _size.r,
                            fit: BoxFit.cover,
                            image: _imageUrl!,
                            imageErrorBuilder: (c, o, s) => Image.asset(_avatar ?? Assets.imagesImgAvatarPlaceholder, width: _size.r, height: _size.r, fit: BoxFit.cover),
                          ),
                        ),
            ),
          ),
          if (_canEdit)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      File? file = await onPickImagesPressed(context);
                      if (file != null && _onAttachImage != null) {
                        _onAttachImage!(file);
                      }
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
