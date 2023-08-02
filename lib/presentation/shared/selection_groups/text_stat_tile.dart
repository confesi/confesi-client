
import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class TextStatTile extends StatefulWidget {
  const TextStatTile({
    super.key,
    required this.leftText,
    this.onTap,
    required this.rightText,
    this.topRounded = true,
    this.bottomRounded = true,
    this.backgroundColor,
    this.foregroundColor,
    this.secondaryColor,
    this.noHorizontalPadding = false,
  });

  final String leftText;
  final String? rightText;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? secondaryColor;
  final bool topRounded;
  final bool bottomRounded;
  final bool noHorizontalPadding;

  @override
  State<TextStatTile> createState() => _TextStatTileState();
}

class _TextStatTileState extends State<TextStatTile> {
  Widget buildChild(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topRounded ? 15 : 0),
          topRight: Radius.circular(widget.topRounded ? 15 : 0),
          bottomRight: Radius.circular(widget.bottomRounded ? 15 : 0),
          bottomLeft: Radius.circular(widget.bottomRounded ? 15 : 0),
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
                  Text(
                    widget.leftText,
                    style: kTitle.copyWith(
                      color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.rightText!,
                      textAlign: TextAlign.right,
                      style: kTitle.copyWith(
                        color: widget.secondaryColor ?? Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.onTap == null
        ? buildChild(context)
        : TouchableOpacity(
            onTap: () => widget.onTap!(),
            child: buildChild(context),
          );
  }
}
