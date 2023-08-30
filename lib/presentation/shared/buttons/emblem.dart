
import 'package:confesi/constants/shared/constants.dart';

import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class EmblemButton extends StatelessWidget {
  const EmblemButton(
      {required this.backgroundColor, required this.icon, required this.onPress, required this.iconColor, Key? key})
      : super(key: key);

  final VoidCallback onPress;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onPress(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onBackground, width:borderSize,strokeAlign: BorderSide.strokeAlignInside),
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
