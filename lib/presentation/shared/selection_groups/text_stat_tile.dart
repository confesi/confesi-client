import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class TextStatTile extends StatefulWidget {
  const TextStatTile({
    super.key,
    required this.leftText,
    this.onTap,
    this.rightText,
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
          topLeft: Radius.circular(widget.topRounded ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius : 0),
          topRight: Radius.circular(widget.topRounded ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius : 0),
          bottomRight: Radius.circular(widget.bottomRounded ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius : 0),
          bottomLeft: Radius.circular(widget.bottomRounded ? Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius : 0),
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
                  Expanded(
                    child: Text(
                      widget.leftText,
                      style: kTitle.copyWith(
                        color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  widget.rightText != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.rightText!,
                              textAlign: TextAlign.right,
                              style: kBody.copyWith(
                                color: widget.secondaryColor ?? Theme.of(context).colorScheme.secondary,
                              ),
                            )
                          ],
                        )
                      : Container()
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
