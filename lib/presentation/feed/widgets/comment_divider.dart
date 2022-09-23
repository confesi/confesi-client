import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/numbers/large_number_formatter.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/buttons/option.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../shared/overlays/button_options_sheet.dart';

class CommentDivider extends StatelessWidget {
  const CommentDivider({
    required this.comments,
    Key? key,
  }) : super(key: key);

  final int comments;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      tooltip: 'comment sorting + number of comments',
      tooltipLocation: TooltipLocation.above,
      onTap: () => showButtonOptionsSheet(
        context,
        [
          OptionButton(
            onTap: () {
              print('Best tapped');
            },
            text: 'Best',
            icon: CupertinoIcons.bolt,
          ),
          OptionButton(
            onTap: () {
              print('Liked tapped');
            },
            text: 'Liked',
            icon: CupertinoIcons.sort_up,
          ),
          OptionButton(
            onTap: () {
              print('Hated tapped');
            },
            text: 'Hated',
            icon: CupertinoIcons.sort_down,
          ),
          OptionButton(
            onTap: () {
              print('Recent tapped');
            },
            text: 'Recent',
            icon: CupertinoIcons.clock,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
              width: 0.7,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sort comments by: best',
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                largeNumberFormatter(comments),
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
