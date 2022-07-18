import 'package:flutter/material.dart';

import '../../styles/typography.dart';
import '../buttons/touchable_opacity.dart';

class LinkText extends StatelessWidget {
  const LinkText(
      {required this.onPress,
      required this.linkText,
      required this.text,
      this.widthMultiplier = 100,
      Key? key})
      : super(key: key);

  final int widthMultiplier;
  final String text;
  final String linkText;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width / 100;
    return SizedBox(
      width: widthFactor * widthMultiplier,
      child: TouchableOpacity(
        onTap: () => onPress(),
        child: Container(
          // transparent hitbox trick
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                children: <TextSpan>[
                  TextSpan(
                      text: text,
                      style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(
                    text: linkText,
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
