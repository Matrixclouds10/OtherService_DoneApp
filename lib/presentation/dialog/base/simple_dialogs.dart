import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/text_styles.dart';

Future<dynamic> showQuestionDialog(
  BuildContext context, {
  String? question,
  String? desc,
  String? btnTextPositive,
  String? btnTextNegative,
  VoidCallback? onPositiveClick,
  VoidCallback? onNegativeClick,
}) {
  final dialog = AwesomeDialog(
    context: context,
    // dialogType: DialogType.question,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: question,
    desc: desc,
    dialogType: DialogType.noHeader,
    btnOkColor: Theme.of(context).primaryColor,
    btnCancelColor: Theme.of(context).primaryColor,
    descTextStyle: const TextStyle().descriptionStyle(),
    titleTextStyle: const TextStyle().regularStyle(),
    alignment: AlignmentDirectional.centerStart,
    showCloseIcon: true,
    btnCancelOnPress: onNegativeClick,
    btnOkOnPress: onPositiveClick,
    btnOkText: btnTextPositive,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    btnCancelText: btnTextNegative,
  );

  return dialog.show(); // returning result
}

void showSuccessDialog(
  BuildContext context,
  String title,
  String desc,
) {
  AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      useRootNavigator: true,
      title: 'Succes',
      desc: 'Dialog description here......................',
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (t) {
        debugPrint('Dialog Dismiss from callback');
      }).show();
}

// will be used for simple custom dialogs like signing out loading indicator
void showCustomDialog(BuildContext context, Widget body,
    {required Function onDismissCallback, bool isCancellable = false}) {
  AwesomeDialog(
          dialogBackgroundColor: Theme.of(context).primaryColor,
          context: context,
          animType: AnimType.bottomSlide,
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
          dialogType: DialogType.noHeader,
          dismissOnBackKeyPress: isCancellable,
          useRootNavigator: true,
          onDismissCallback: (t) => onDismissCallback,
          body: body)
      .show();
}

// will be used for simple custom dialogs like signing out loading indicator
void showAutoHideCustomDialog(BuildContext context, Widget body,
    {required Function onDismiss}) async {
  AwesomeDialog(
          context: context,
          dialogBackgroundColor: Theme.of(context).cardColor,
          animType: AnimType.bottomSlide,
          headerAnimationLoop: false,
          autoHide: const Duration(seconds: 3),
          onDismissCallback: (t) => {onDismiss()},
          dismissOnTouchOutside: false,
          dialogType: DialogType.noHeader,
          dismissOnBackKeyPress: false,
          useRootNavigator: true,
          body: body)
      .show();
}

void showAutoHideDialog(BuildContext context, Widget body) async {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    animType: AnimType.scale,
    title: 'Auto Hide Dialog',
    desc: 'AutoHide after 2 seconds',
    autoHide: const Duration(seconds: 2),
  ).show();
}
