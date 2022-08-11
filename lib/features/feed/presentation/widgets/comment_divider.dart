import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/buttons/option.dart';
import 'package:Confessi/core/widgets/buttons/touchable_opacity.dart';
import 'package:Confessi/core/widgets/sheets/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentDivider extends StatelessWidget {
  const CommentDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      tooltip: 'how the comments should be arranged',
      tooltipLocation: TooltipLocation.above,
      onTap: () => showButtonOptionsSheet(
        context,
        [
          OptionButton(
            onTap: () {
              Navigator.pop(context);
              print('Best tapped');
            },
            text: 'Best',
            icon: CupertinoIcons.bolt,
          ),
          OptionButton(
            onTap: () {
              Navigator.pop(context);
              print('Liked tapped');
            },
            text: 'Liked',
            icon: CupertinoIcons.sort_up,
          ),
          OptionButton(
            onTap: () {
              Navigator.pop(context);
              print('Hated tapped');
            },
            text: 'Hated',
            icon: CupertinoIcons.sort_down,
          ),
          OptionButton(
            onTap: () {
              Navigator.pop(context);
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
          child: Text(
            'Sort comments by: best',
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
