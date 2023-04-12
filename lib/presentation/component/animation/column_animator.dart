import 'package:weltweit/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/resources/values_manager.dart';
import '../spaces.dart';

class ColumnAnimator extends StatefulWidget {
  final List<Widget>? children;

  const ColumnAnimator({
    Key? key,
    this.children,
  }) : super(key: key);

  @override
  _ColumnAnimatorState createState() => _ColumnAnimatorState();
}

class _ColumnAnimatorState extends State<ColumnAnimator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight,
      child: AnimationConfiguration.synchronized(
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: AnimationLimiter(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    (widget.children ?? []).length,
                    (index) => Column(
                          children: [
                            const VerticalSpace(kFormPaddingVertical),
                            widget.children![index]
                          ],
                        )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
