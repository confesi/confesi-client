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
    this.topRounded = false,
    this.bottomRounded = false,
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.topRounded ? 10 : 0),
            topRight: Radius.circular(widget.topRounded ? 10 : 0),
            bottomRight: Radius.circular(widget.bottomRounded ? 10 : 0),
            bottomLeft: Radius.circular(widget.bottomRounded ? 10 : 0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: widget.noHorizontalPadding ? 0 : 15),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.secondaryColor),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        widget.text,
                        style: kTitle.copyWith(
                          color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    widget.secondaryText != null
                        ? Expanded(
                            child: Text(
                              widget.secondaryText!,
                              textAlign: TextAlign.right,
                              style: kTitle.copyWith(
                                color: widget.secondaryColor ?? Theme.of(context).colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
              child: Container(
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
