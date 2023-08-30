import 'package:confesi/constants/shared/constants.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class BoolSelectionTile extends StatefulWidget {
  const BoolSelectionTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.secondaryText,
    this.topRounded = true,
    this.bottomRounded = true,
    this.isActive = false,
    this.backgroundColor,
    this.foregroundColor,
    this.secondaryColor,
    this.noHorizontalPadding = false,
  });

  final IconData icon;
  final String text;
  final String? secondaryText;
  final VoidCallback onTap;
  final bool topRounded;
  final bool bottomRounded;
  final bool isActive;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? secondaryColor;
  final bool noHorizontalPadding;

  @override
  State<BoolSelectionTile> createState() => _BoolSelectionTileState();
}

class _BoolSelectionTileState extends State<BoolSelectionTile> {
  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => widget.onTap(),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
          border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: borderSize),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
                widget.topRounded ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius : 0),
            topRight: Radius.circular(
                widget.topRounded ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius : 0),
            bottomRight: Radius.circular(widget.bottomRounded
                ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius
                : 0),
            bottomLeft: Radius.circular(widget.bottomRounded
                ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius
                : 0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: widget.noHorizontalPadding ? 0 : 15),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.secondaryColor),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Text(
                        widget.text,
                        style: kTitle.copyWith(
                          color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    widget.secondaryText != null
                        ? Text(
                            widget.secondaryText!,
                            textAlign: TextAlign.right,
                            style: kTitle.copyWith(
                              color: widget.secondaryColor ?? Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(),
                    widget.secondaryText != null ? const SizedBox(width: 10) : Container(),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: widget.noHorizontalPadding ? 0 : 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary, width: 3),
              ),
              height: 20,
              width: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isActive
                      ? widget.foregroundColor ?? Theme.of(context).colorScheme.primary
                      : widget.backgroundColor ?? Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
