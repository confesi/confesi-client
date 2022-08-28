import 'package:Confessi/presentation/create_post/widgets/picker_sheet.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class TextRow extends StatelessWidget {
  const TextRow({
    Key? key,
    this.bottomLine = false,
    required this.leftText,
    required this.rightText,
  }) : super(key: key);

  final bool bottomLine;
  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: .35,
          ),
          bottom: bottomLine
              ? BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: .35,
                )
              : BorderSide.none,
        ),
      ),
      child: TouchableOpacity(
        onTap: () => print('row tapped'),
        child: Container(
          // Transparent hitbox trick.
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        leftText,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        CupertinoIcons.pen,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    rightText,
                    style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
