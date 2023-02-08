import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/material.dart';

enum WatchedIndicatorType {
  watch,
  unwatch,
  makeHome,
}

class WatchedUniversityIndicator extends StatelessWidget {
  const WatchedUniversityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("tapped"),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Text(
          "Watch",
          style: kDetail.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
