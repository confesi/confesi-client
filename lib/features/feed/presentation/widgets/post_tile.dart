import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:Confessi/core/widgets/layout/line.dart';
import 'package:Confessi/core/widgets/text/group.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  const PostTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //! Top Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.flame,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: GroupText(
                  body: "1 hour ago • Engineering",
                  header: "Politics",
                  leftAlign: true,
                  small: true,
                ),
              ),
              TouchableOpacity(
                  onTap: () => print("tap"),
                  child: Container(
                    // Transparent container hitbox trick.
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        CupertinoIcons.ellipsis,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 30),
          //! Middle row
          Text(
            "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available.",
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.primary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          //! Bottom row
          Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const VoteTile(
                isActive: true,
                value: 31,
                icon: CupertinoIcons.hand_thumbsup_fill,
              ),
              const VoteTile(
                isActive: false,
                value: 19,
                icon: CupertinoIcons.hand_thumbsdown_fill,
              ),
              Text(
                "4 comments",
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
