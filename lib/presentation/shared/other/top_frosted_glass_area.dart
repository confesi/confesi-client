import 'dart:ui';

import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:flutter/material.dart';

/// To use, add [topSafeArea(context)] as a padding above your scrollable widget
/// that you're wrapping with this [TopFrostedGlassArea]. This will offset it by
/// the same height that the frosted glass covers.
class TopFrostedGlassArea extends StatelessWidget {
  const TopFrostedGlassArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
          ignoring: false,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: topSafeArea(context),
                // padding: EdgeInsets.only(top: topSafeArea(context)),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.4)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
