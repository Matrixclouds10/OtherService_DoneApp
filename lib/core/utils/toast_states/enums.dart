
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../routing/navigation_services.dart';

enum RequestState{
  loading,
  loaded,
  error,
}
//Toast ***************************************
void showToast({required String text, ToastStates state =ToastStates.success ,ToastGravity? gravity,int? timeInSecForIosWeb}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: timeInSecForIosWeb??5,
        backgroundColor: chooseColor(state, NavigationService.navigationKey.currentContext!),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { success, error, warning }

Color chooseColor(ToastStates state, context) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Theme.of(context).primaryColor;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

