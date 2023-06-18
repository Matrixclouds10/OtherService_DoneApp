import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Image imageFromBase64String(String base64String) {
  return Image.memory(
    base64Decode(base64String),
  );
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

// Future<String> fileFromBase64String(String base64String) async {
//   final fileBase64String = base64String.split('base64,').last;
//   Uint8List bytes = base64Decode(fileBase64String);
//   String dir = (await getApplicationDocumentsDirectory()).path;
//   File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.mp3");
//   await file.writeAsBytes(bytes);
//   return file.path;
// }
