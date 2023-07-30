import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class SwitchSelectionTile extends StatefulWidget {
  const SwitchSelectionTile({
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
  State<SwitchSelectionTile> createState() => _SwitchSelectionTileState();
}

class _SwitchSelectionTileState extends State<SwitchSelectionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topRounded ? 15 : 0),
          topRight: Radius.circular(widget.topRounded ? 15 : 0),
          bottomRight: Radius.circular(widget.bottomRounded ? 15 : 0),
          bottomLeft: Radius.circular(widget.bottomRounded ? 15 : 0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.noHorizontalPadding ? 0 : 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.secondaryColor),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.text,
                            style: kTitle.copyWith(
                              color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          widget.secondaryText != null
                              ? Text(
                                  widget.secondaryText!,
                                  textAlign: TextAlign.right,
                                  style: kBody.copyWith(
                                    color: widget.secondaryColor ?? Theme.of(context).colorScheme.onSurface,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    widget.secondaryText != null ? const SizedBox(width: 10) : Container(),
                  ],
                ),
              ),
            ),
            CupertinoSwitch(
              focusColor: Theme.of(context).colorScheme.secondary,
              activeColor: Theme.of(context).colorScheme.secondary,
              value: widget.isActive,
              onChanged: (_) => widget.onTap(),
            )
          ],
        ),
      ),
    );
  }
}
