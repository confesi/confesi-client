import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../../../core/styles/typography.dart';
import 'package:flutter/material.dart';

class TextLimitTracker extends StatelessWidget {
  const TextLimitTracker({
    required this.value,
    this.noText = false,
    Key? key,
  }) : super(key: key);

  final double value;
  final bool noText;

  String getText() {
    if (value >= 1) {
      return "Limit reached";
    } else if (value > .7) {
      return "Slow down...";
    } else {
      return "Limit";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      autoPlay: value >= 1,
      shakeConstant: ShakeSlowConstant2(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              color: value >= 1 ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary,
              value: value,
            ),
          ),
          const SizedBox(width: 10),
          noText
              ? Container()
              : Flexible(
                  child: Text(
                    getText(),
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ],
      ),
    );
  }
}
