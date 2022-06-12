import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

import '../../constants/typography.dart';

class TouchableTextButton extends StatelessWidget {
  const TouchableTextButton(
      {this.textAlignCenter = false, required this.onTap, required this.text, Key? key})
      : super(key: key);

  final String text;
  final VoidCallback onTap;
  final bool textAlignCenter;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        // transparent hitbox trick
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            text,
            style: kBody.copyWith(color: Theme.of(context).colorScheme.error),
            textAlign: textAlignCenter ? TextAlign.center : TextAlign.left,
          ),
        ),
      ),
    );
  }
}
