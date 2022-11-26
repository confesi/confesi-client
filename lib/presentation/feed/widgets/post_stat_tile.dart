import 'package:Confessi/presentation/feed/widgets/post_stat_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostStatTile extends StatelessWidget {
  const PostStatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(15),
        //   bottomRight: Radius.circular(15),
        // ),
        color: Theme.of(context).colorScheme.secondary,
        // color: Color.fromARGB(255, 140, 206, 174),
        // color: Color.fromARGB(255, 232, 138, 138),
        // color: Color(0xffB2A4FF),
        // color: Color(0xff277BC0),
      ),
      width: double.infinity,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            PostStatItem(text: "Back", icon: CupertinoIcons.arrow_turn_up_left, onTap: () => print("tap")),
            PostStatItem(text: "Share", icon: CupertinoIcons.share, onTap: () => print("tap")),
            PostStatItem(text: "124", icon: CupertinoIcons.chat_bubble, onTap: () => print("tap")),
            PostStatItem(text: "12.2k", icon: CupertinoIcons.hand_thumbsdown, onTap: () => print("tap")),
            PostStatItem(text: "413", icon: CupertinoIcons.hand_thumbsup, onTap: () => print("tap")),
          ],
        ),
      ),
    );
  }
}
