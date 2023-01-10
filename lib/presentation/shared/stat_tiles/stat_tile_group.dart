import 'stat_tile_item.dart';
import '../behaviours/init_opacity.dart';
import '../behaviours/init_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatTileGroup extends StatelessWidget {
  const StatTileGroup({
    super.key,
    required this.icon1OnPress,
    required this.icon2OnPress,
    required this.icon3OnPress,
    required this.icon4OnPress,
    required this.icon5OnPress,
  });

  final VoidCallback icon1OnPress;
  final VoidCallback icon2OnPress;
  final VoidCallback icon3OnPress;
  final VoidCallback icon4OnPress;
  final VoidCallback icon5OnPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        width: double.infinity,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                StatTileItem(text: "Back", icon: CupertinoIcons.arrow_turn_up_left, onTap: () => icon1OnPress()),
                StatTileItem(text: "124", icon: CupertinoIcons.chat_bubble, onTap: () => icon2OnPress()),
                StatTileItem(text: "Share", icon: CupertinoIcons.share, onTap: () => icon3OnPress()),
                StatTileItem(text: "12.2k", icon: CupertinoIcons.arrow_up, onTap: () => icon4OnPress()),
                StatTileItem(text: "413", icon: CupertinoIcons.arrow_down, onTap: () => icon5OnPress()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}