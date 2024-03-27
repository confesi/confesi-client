import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class CircleActionButton extends StatelessWidget {
  const CircleActionButton(
      {super.key, required this.onTap, required this.bgColor, required this.color, required this.icon});

  final VoidCallback onTap;
  final Color bgColor;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: FittedBox(
            child: Icon(
              icon,
              color: color,
              
            ),
          ),
        ),
      ),
    );
  }
}
