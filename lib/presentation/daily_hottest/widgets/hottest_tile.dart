import 'dart:ui';

import 'package:Confessi/constants/daily_hottest/constants.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/is_plural.dart';
import 'package:Confessi/core/utils/large_number_formatter.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/text/header_group.dart';

class HottestTile extends StatefulWidget {
  const HottestTile({
    required this.currentIndex,
    required this.thisIndex,
    required this.comments,
    required this.hates,
    required this.likes,
    required this.title,
    required this.university,
    required this.universityImagePath,
    required this.year,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final int thisIndex;
  final int comments;
  final int likes;
  final int hates;
  final String title;
  final String university;
  final String universityImagePath;
  final int year;

  @override
  State<HottestTile> createState() => _HottestTileState();
}

class _HottestTileState extends State<HottestTile> {
  bool get isSelected => widget.currentIndex == widget.thisIndex;

  String getComments() => isPlural(widget.comments)
      ? '${largeNumberFormatter(widget.comments)} comments'
      : '${largeNumberFormatter(widget.comments)} comment';

  String getLikes() => isPlural(widget.likes)
      ? '${largeNumberFormatter(widget.likes)} likes'
      : '${largeNumberFormatter(widget.likes)} like';

  String getHates() => isPlural(widget.hates)
      ? '${largeNumberFormatter(widget.hates)} hates'
      : '${largeNumberFormatter(widget.hates)} hate';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: isSelected ? 1 : 0.75,
                  child: AnimatedContainer(
                    width: double.infinity,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: isSelected
                        ? constraints.maxHeight
                        : constraints.maxHeight * .8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.secondary,
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: Text(
                            '${getComments()} · ${getLikes()} · ${getHates()}',
                            style: kDetail.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            child: Image.asset(
                              widget.universityImagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                right: 5,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '0${widget.thisIndex + 1}',
                                    style: kFaded.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: HeaderGroupText(
                                  onSecondaryColors: false,
                                  multiLine: true,
                                  spaceBetween: 20,
                                  left: true,
                                  header: widget.title.isEmpty
                                      ? kNoTitleProvided
                                      : widget.title,
                                  body:
                                      '${widget.university}, Year ${widget.year}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
