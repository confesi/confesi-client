import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../../core/styles/typography.dart';

class ReactionTile extends StatefulWidget {
  const ReactionTile({
    super.key,
    required this.amount,
    required this.icon,
    required this.iconColor,
    this.simpleView = false,
    this.isSelected = false,
    this.onTap,
    this.extraLeftPadding = false,
  });

  final bool simpleView;
  final int amount;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool extraLeftPadding;

  @override
  _ReactionTileState createState() => _ReactionTileState();
}

class _ReactionTileState extends State<ReactionTile> with SingleTickerProviderStateMixin {
  late AnimationController animController;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: animController.value * 0.5 + 1.0, // Adjust the scale here
          child: Icon(
            widget.icon,
            color: widget.isSelected ? widget.iconColor : Theme.of(context).colorScheme.onSurface,
            size: 17,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          largeNumberFormatter(widget.amount),
          style: kTitle.copyWith(
            color: widget.isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );

    if (widget.onTap != null) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.onTap != null) {
            widget.onTap!();
            animController.forward(from: 0.0).then((value) {
              animController.reverse(from: 1.0);
            });
            animController.addListener(() {
              setState(() {});
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding:
              EdgeInsets.only(top: 11, bottom: 10, left: widget.simpleView ? 0 : 15, right: widget.simpleView ? 0 : 15),
          decoration: BoxDecoration(
            border: widget.simpleView
                ? null
                : Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.8,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
            color: widget.simpleView ? Colors.transparent : Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: content,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: widget.extraLeftPadding ? 10 : 0),
      child: content,
    );
  }
}
