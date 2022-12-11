import 'package:Confessi/presentation/feed/widgets/post_stat_item.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostStatTile extends StatelessWidget {
  const PostStatTile({
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
                PostStatItem(text: "Back", icon: CupertinoIcons.arrow_turn_up_left, onTap: () => icon1OnPress()),
                PostStatItem(text: "124", icon: CupertinoIcons.chat_bubble, onTap: () => icon2OnPress()),
                PostStatItem(text: "Share", icon: CupertinoIcons.share, onTap: () => icon3OnPress()),
                PostStatItem(text: "12.2k", icon: CupertinoIcons.hand_thumbsdown, onTap: () => icon4OnPress()),
                PostStatItem(text: "413", icon: CupertinoIcons.hand_thumbsup, onTap: () => icon5OnPress()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
