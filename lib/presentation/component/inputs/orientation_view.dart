import 'package:flutter/material.dart';

class OrientationView extends StatelessWidget {
  final bool _isHorizontal;
  final List<Widget> _children;

  const OrientationView({
    Key? key,
    bool isHorizontal = false,
    List<Widget> children = const <Widget>[],
  })  : _isHorizontal = isHorizontal,
        _children = children,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_isHorizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _children,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children,
      );
    }
  }
}
