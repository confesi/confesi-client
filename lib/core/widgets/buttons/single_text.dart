import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/typography.dart';
import 'touchable_opacity.dart';

class SingleTextButton extends StatelessWidget {
  const SingleTextButton(
      {this.topPadding = 0.0,
      this.bottomPadding = 0.0,
      required this.backgroundColor,
      required this.textColor,
      required this.text,
      this.horizontalPadding = 0.0,
      required this.onPress,
      Key? key})
      : super(key: key);

  final Color textColor;
  final Color backgroundColor;
  final String text;
  final double topPadding;
  final double bottomPadding;
  final double horizontalPadding;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: topPadding,
          bottom: bottomPadding),
      child: TouchableOpacity(
        onTap: () => onPress(),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Text(
              text,
              style: kHeader.copyWith(
                color: textColor,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
