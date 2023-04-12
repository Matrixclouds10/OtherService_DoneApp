import 'package:flutter/material.dart';

AppBar kAppBar(
    {String? location, String? title, required List<Widget> actions}) {
  return AppBar(
    elevation: 0.4,
    titleSpacing: -8,
    automaticallyImplyLeading: false,
    iconTheme: IconThemeData(color: Colors.grey[600]),
    backgroundColor: Colors.transparent,
    actions: actions,
  );
}
