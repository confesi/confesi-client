import 'stat_tile_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatTileGroup extends StatelessWidget {
  const StatTileGroup({
    super.key,
    required this.icon1Text,
    required this.icon2Text,
    required this.icon4Text,
    required this.icon5Text,
    required this.icon1OnPress,
    required this.icon2OnPress,
    required this.icon4OnPress,
    required this.icon5OnPress,
    required this.icon4Selected,
    required this.icon5Selected,
  });

  final String icon1Text;
  final String icon2Text;
  final String icon4Text;
  final String icon5Text;
  final VoidCallback icon1OnPress;
  final VoidCallback icon2OnPress;
  final VoidCallback icon4OnPress;
  final VoidCallback icon5OnPress;
  final bool icon4Selected;
  final bool icon5Selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).colorScheme.secondary,
        width: double.infinity,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                StatTileItem(text: icon1Text, icon: CupertinoIcons.arrow_turn_up_left, onTap: () => icon1OnPress()),
                StatTileItem(text: icon2Text, icon: CupertinoIcons.chat_bubble, onTap: () => icon2OnPress()),
                StatTileItem(
                  text: icon4Text,
                  icon: CupertinoIcons.arrow_up,
                  onTap: () => icon4OnPress(),
                  iconColor: icon4Selected ? Theme.of(context).colorScheme.onErrorContainer : null,
                  textColor: icon4Selected ? Theme.of(context).colorScheme.onErrorContainer : null,
                ),
                StatTileItem(
                  text: icon5Text,
                  icon: CupertinoIcons.arrow_down,
                  onTap: () => icon5OnPress(),
                  iconColor: icon5Selected ? Theme.of(context).colorScheme.onSecondaryContainer : null,
                  textColor: icon5Selected ? Theme.of(context).colorScheme.onSecondaryContainer : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
