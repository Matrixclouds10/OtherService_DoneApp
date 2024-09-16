import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info, other }

class AppSnackbar {
  static void show({
    required BuildContext context,
    String? title, //TODO remove this
    required String message,
    SnackbarType type = SnackbarType.other,
  })
  {
    AnimatedSnackBarType snackBarType = AnimatedSnackBarType.info;
    switch (type) {
      case SnackbarType.success:
        snackBarType = AnimatedSnackBarType.success;
        break;
      case SnackbarType.error:
        snackBarType = AnimatedSnackBarType.error;
        break;
      case SnackbarType.warning:
        snackBarType = AnimatedSnackBarType.warning;
        break;
      case SnackbarType.info:
        snackBarType = AnimatedSnackBarType.info;
        break;
      case SnackbarType.other:
        snackBarType = AnimatedSnackBarType.info;
        break;
    }

    AnimatedSnackBar.material(
      message,
      type: snackBarType,
      duration: Duration(seconds: 6),
      mobileSnackBarPosition:
          MobileSnackBarPosition.top, // Position of snackbar on mobile devices
    ).show(context);
  }
}
