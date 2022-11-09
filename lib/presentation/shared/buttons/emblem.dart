import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';

import '../button_touch_effects/touchable_opacity.dart';

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
    return TouchableScale(
      onTap: () => onPress(),
      child: Container(
        decoration: BoxDecoration(
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
