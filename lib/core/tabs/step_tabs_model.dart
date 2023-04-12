import 'package:flutter/material.dart';

@immutable
class CreateStepTab {
  const CreateStepTab({
    required this.name,
    required this.widget,
    required this.index,
  });

  final String name;
  final Widget widget;
  final int index;
}
