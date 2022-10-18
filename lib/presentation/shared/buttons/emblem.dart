import 'package:Confessi/presentation/shared/button_touch_effects/touchable_burst.dart';
import 'package:flutter/cupertino.dart';

import '../button_touch_effects/touchable_opacity.dart';

class EmblemButton extends StatelessWidget {
  const EmblemButton(
      {required this.backgroundColor,
      required this.icon,
      required this.onPress,
      required this.iconColor,
      Key? key})
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
          color: backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
