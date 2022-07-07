import 'package:flutter/material.dart';

import '../../constants/typography.dart';
import 'touchable_opacity.dart';

class LongButton extends StatelessWidget {
  const LongButton(
      {required this.textColor,
      required this.backgroundColor,
      required this.onPress,
      required this.text,
      Key? key})
      : super(key: key);

  final VoidCallback onPress;
  final String text;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          child: Text(
            text,
            style: kBody.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
