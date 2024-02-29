import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weltweit/core/utils/echo.dart';

class FirebaseMethods {
  Future<bool> hideForIos() async {
    if(!Platform.isIOS) return false;
    try {
      return await FirebaseFirestore.instance.collection('settings').doc('ios').get().then((value) {
        bool? status = value['status'];

        kEcho("status $status");
        return status ?? true;
      });
    } catch (e) {
      kEcho("error $e");
    }
    return true;
  }
}
