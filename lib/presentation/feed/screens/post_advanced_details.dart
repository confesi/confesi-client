import 'package:Confessi/core/constants/shared/buttons.dart';
import 'package:Confessi/core/utils/numbers/add_commas_to_number.dart';
import 'package:Confessi/presentation/shared/behaviours/overscroll.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/spread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../../../core/constants/feed/constants.dart';
import '../../shared/overlays/info_sheet.dart';

class PostAdvancedDetailsScreen extends StatelessWidget {
  const PostAdvancedDetailsScreen({
    Key? key,
    required this.comments,
    required this.faculty,
    required this.genre,
    required this.hates,
    required this.likes,
    required this.moderationStatus,
    required this.saves,
    required this.university,
    required this.year,
    required this.universityFullName,
  }) : super(key: key);

  final String universityFullName;
  final int likes;
  final int hates;
  final int comments;
  final int saves;
  final String university;
  final String faculty;
  final String genre;
  final int year;
  final String moderationStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              bottomBorder: false,
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
              child: ScrollableView(
                horizontalPadding: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Quick stats',
                      style: kTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 7.5),
                    SpreadRowText(
                      leftText: 'Likes',
                      rightText: addCommasToNumber(likes),
                    ),
                    SpreadRowText(
                      leftText: 'Hates',
                      rightText: addCommasToNumber(hates),
                    ),
                    SpreadRowText(
                      leftText: 'Comments',
                      rightText: addCommasToNumber(comments),
                    ),
                    SpreadRowText(
                      leftText: 'Saves',
                      rightText: addCommasToNumber(saves),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'About the poster',
                      style: kTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 7.5),
                    SpreadRowText(
                      leftText: 'University (abbr.)',
                      rightText: university,
                    ),
                    SpreadRowText(
                      leftText: 'University (full)',
                      rightText: universityFullName,
                    ),
                    SpreadRowText(
                      leftText: 'Faculty',
                      rightText: faculty,
                    ),
                    SpreadRowText(
                      leftText: 'Genre',
                      rightText: genre,
                    ),
                    SpreadRowText(
                      leftText: 'Year of study',
                      rightText: year.toString(),
                    ),
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
                    SpreadRowText(
                      leftText: 'Post status',
                      rightText: moderationStatus,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
