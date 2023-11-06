import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextClickWidget extends StatelessWidget {
  final String? _text;
  final String? _subText;
  final Color? _textColor;
  final GestureTapCallback? _onTap;

  const TextClickWidget({
    super.key,
    required String? text,
    required String? subText,
    Color? textColor,
    required GestureTapCallback? onTap,
  })  : _text = text,
        _subText = subText,
        _textColor = textColor,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${_text ?? ''} ',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 14,
                height: 1.4,
                color:
                    _textColor ?? Theme.of(context).textTheme.bodySmall!.color),
          ),
          TextSpan(
            text: _subText ?? '',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).primaryColorDark,
                height: 1.4,
                fontSize: 14,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = _onTap,
          ),
        ],
      ),
    );
  }
}
