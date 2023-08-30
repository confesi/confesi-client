import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import 'package:flutter/material.dart';

class RectangleTile extends StatefulWidget {
  const RectangleTile({
    Key? key,
    required this.leftText,
    required this.rightText,
    this.backgroundColor,
    this.foregroundColor,
    this.secondaryColor,
    required this.leftIcon,
    required this.rightIcon,
    required this.onLeftTap,
    required this.onRightTap,
  }) : super(key: key);

  final IconData leftIcon;
  final IconData rightIcon;
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
          color: Theme.of(context).colorScheme.onBackground,
          width: borderSize,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: TouchableScale(
                onTap: widget.onLeftTap,
                child: Container(
                  color: Colors.transparent, // transparent hitbox trick
                  child: Column(
                    children: [
                      Icon(
                        widget.leftIcon,
                        color: widget.secondaryColor ?? Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.leftText,
                        style: kDetail.copyWith(
                          color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
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
              child: TouchableScale(
                onTap: widget.onRightTap,
                child: Container(
                  color: Colors.transparent, // transparent hitbox trick
                  child: Column(
                    children: [
                      Icon(
                        widget.rightIcon,
                        color: widget.secondaryColor ?? Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.rightText,
                        style: kDetail.copyWith(
                          color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
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
