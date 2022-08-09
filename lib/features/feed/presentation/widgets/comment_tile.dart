import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/utils/large_number_formatter.dart';
import 'package:Confessi/core/widgets/text/tight_group.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/widgets/buttons/touchable_opacity.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    required this.votes,
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;
  final int votes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.flame,
                    size: 15,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const TightGroupText(
                header: 'Matthew',
                body: '2h',
              ),
              const Spacer(),
              TouchableOpacity(
                tooltip: 'comment options',
                tooltipLocation: TooltipLocation.above,
                onTap: () => print('tap'),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.primary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'reply =>',
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 10),
              VoteTileSet(
                votes: votes,
                isLarge: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
