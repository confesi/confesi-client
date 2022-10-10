import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
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
  });

  final IconData icon;
  final String text;
  final String? secondaryText;
  final VoidCallback onTap;
  final bool topRounded;
  final bool bottomRounded;
  final bool isActive;

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
          color: Theme.of(context).colorScheme.background,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
                    Icon(widget.icon),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        widget.text,
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Container(),
                    widget.secondaryText != null
                        ? const SizedBox(width: 10)
                        : Container(),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 3),
              ),
              height: 20,
              width: 20,
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
