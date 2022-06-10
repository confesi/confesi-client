import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

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
                style: kBody.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Text(
//         text,
//         style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
//         textAlign: TextAlign.center,
//       ),