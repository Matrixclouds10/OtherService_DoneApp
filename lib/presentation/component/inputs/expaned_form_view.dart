import 'package:flutter/material.dart';

class ExpandedHelperView extends StatelessWidget {
  final bool _isExpanded;
  final Widget _child;

  const ExpandedHelperView({
    Key? key,
    bool isExpanded = false,
    required Widget child,
  })  : _isExpanded = isExpanded,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_isExpanded) {
      return Expanded(
        flex: 3,
        child: _child,
      );
    } else {
      return SizedBox(
        child: _child,
      );
    }
  }
}
