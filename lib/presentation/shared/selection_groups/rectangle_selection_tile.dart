import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import 'package:flutter/material.dart';

class RectangleTile extends StatefulWidget {
  const RectangleTile({
    super.key,
    required this.leftText,
    required this.rightText,
    this.backgroundColor,
    this.foregroundColor,
    this.secondaryColor,
    required this.icon,
    required this.onLeftTap,
    required this.onRightTap,
  });

  final IconData icon;
  final String leftText;
  final String rightText;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? secondaryColor;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  @override
  State<RectangleTile> createState() => _RectangleTileState();
}

class _RectangleTileState extends State<RectangleTile> {
  Widget buildChild(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: TouchableOpacity(
                onTap: () => widget.onLeftTap(),
                child: Container(
                  // transparent hitbox trick
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Icon(
                        widget.icon,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.leftText,
                        style: kDetail.copyWith(
                          color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TouchableOpacity(
                onTap: () => widget.onRightTap,
                child: Container(
                  // transparent hitbox trick
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Icon(
                        widget.icon,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.rightText,
                        style: kDetail.copyWith(
                          color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildChild(context);
  }
}
