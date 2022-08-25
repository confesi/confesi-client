import 'package:Confessi/constants/shared/buttons.dart';
import 'package:Confessi/presentation/shared/behaviours/overscroll.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/sheets/info_sheet.dart';
import 'package:Confessi/presentation/shared/text/spread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../../../constants/feed/constants.dart';

class PostAdvancedDetailsScreen extends StatelessWidget {
  const PostAdvancedDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              heroAnimEnabled: false,
              centerWidget: Text(
                "Advanced Details",
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: CupertinoScrollbar(
                child: ScrollConfiguration(
                  behavior: NoOverScrollSplash(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            'Quick stats',
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SpreadRowText(
                              leftText: 'Likes', rightText: '182,193'),
                          const SpreadRowText(
                              leftText: 'Hates', rightText: '12,193'),
                          const SpreadRowText(
                              leftText: 'Comments', rightText: '245'),
                          const SpreadRowText(
                              leftText: 'Saves', rightText: '94'),
                          const SizedBox(height: 30),
                          Text(
                            'About the poster',
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SpreadRowText(
                              leftText: 'University',
                              rightText: 'University of Victoria'),
                          const SpreadRowText(
                              leftText: 'Faculty', rightText: 'Engineering'),
                          const SpreadRowText(
                              leftText: 'Genre', rightText: 'Politics'),
                          const SpreadRowText(
                              leftText: 'Year of study', rightText: '2'),
                          const SizedBox(height: 30),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Moderation',
                                style: kTitle.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TouchableOpacity(
                                    tooltip: 'moderation info',
                                    tooltipLocation: TooltipLocation.above,
                                    onTap: () => showInfoSheet(
                                      context,
                                      kPostStatusTitle,
                                      kPostStatusDescription,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.info,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SpreadRowText(
                              leftText: 'Post status',
                              rightText: 'Not well received'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
