import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.secondaryText,
  });

  final IconData icon;
  final String text;
  final String? secondaryText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            const SizedBox(width: 15),
            Expanded(
              child: Row(
                children: [
                  Text(
                    text,
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  secondaryText != null
                      ? Text(
                          secondaryText!,
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Container(),
                  secondaryText != null
                      ? const SizedBox(width: 10)
                      : Container(),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.arrow_right,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
