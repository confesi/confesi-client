import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class ScrollableIndicator extends StatelessWidget {
  const ScrollableIndicator({this.spinner = false, this.text, this.onPress, Key? key})
      : super(key: key);

  final VoidCallback? onPress;
  final String? text;
  final bool spinner;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: Center(
        child: spinner
            ? const Padding(
                padding:
                    EdgeInsets.only(bottom: 16, top: 8), // posts already have bottom padding of 8
                child: CupertinoActivityIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                child: TextButton(
                  onPressed: () => onPress == null ? null : onPress!(),
                  child: Text(
                    text ?? "blank",
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}
