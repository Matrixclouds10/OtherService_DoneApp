import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String?> onPickImagesPressed(BuildContext context) async {
  List<PlatformFile>? paths;
  const multiPick = false;
  const filesType = FileType.custom;
  const extensions = 'jpg , png , jpeg';
  FocusManager.instance.primaryFocus!.unfocus();

  try {
    paths = (await FilePicker.platform.pickFiles(
      type: filesType,
      allowMultiple: multiPick,
      allowedExtensions: extensions.replaceAll(' ', '').split(','),
    ))
        ?.files;
  } on PlatformException {
    // log(_tag, "Unsupported operation $e");
  } catch (ex) {
    // log(_tag, ex.toString());
  }

  if (paths != null) {
    // log(_tag, 'onPickImagesPressed ${_paths.map((e) => e.name).toString()}');
    return paths[0].path ?? '';
  } else {
    return null;
  }
}
