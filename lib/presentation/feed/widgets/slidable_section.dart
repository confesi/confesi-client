import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constants/shared/enums.dart';

class SlidableSection extends StatelessWidget {
  const SlidableSection({
    required this.icon,
    required this.onPress,
    required this.text,
    this.tooltip,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPress;
  final String text;
  final IconData icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        // Transparent hitbox trick.
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TouchableOpacity(
            tooltipLocation: TooltipLocation.above,
            tooltip: tooltip,
            onTap: () {
              Slidable.of(context)?.close();
              onPress();
            },
            child: Container(
              // Transparent container hitbox trick.
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
