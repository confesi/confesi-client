import 'package:confesi/constants/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../../core/styles/typography.dart';

class ReactionTile extends StatefulWidget {
  const ReactionTile({
    Key? key,
    this.amount, // Made amount nullable
    required this.icon,
    required this.iconColor,
    this.simpleView = false,
    this.isSelected = false,
    this.onTap,
    this.extraLeftPadding = false,
  }) : super(key: key);

  final bool simpleView;
  final int? amount; // Made amount nullable
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool extraLeftPadding;

  @override
  ReactionTileState createState() => ReactionTileState();
}

class ReactionTileState extends State<ReactionTile> with SingleTickerProviderStateMixin {
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
    List<Widget> contentChildren = [];

    contentChildren.add(Transform.scale(
      scale: animController.value * 0.5 + 1.0,
      child: Icon(
        widget.icon,
        color: widget.isSelected ? widget.iconColor : Theme.of(context).colorScheme.onSurface,
        size: 18,
      ),
    ));

    if (widget.amount != null) {
      contentChildren.add(const SizedBox(width: 5));
      contentChildren.add(Text(
        largeNumberFormatter(widget.amount!),
        style: kTitle.copyWith(
          color: widget.isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
        ),
      ));
    }

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: contentChildren,
    );

    if (widget.onTap != null) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap!();
          animController.forward(from: 0.0).then((_) {
            animController.reverse(from: 1.0);
          });
          animController.addListener(() {
            setState(() {});
          });
        },
        child: AnimatedContainer(
          height: 50,
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.only(
            top: 11,
            bottom: 10,
            left: widget.simpleView ? 0 : 15,
            right: widget.simpleView ? 0 : 15,
          ),
          decoration: BoxDecoration(
            border: widget.simpleView
                ? null
                : Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: borderSize,
                  ),
            color: widget.simpleView ? Colors.transparent : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(
              Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius,
            )),
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
