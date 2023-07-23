import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../../core/utils/numbers/large_number_formatter.dart';

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
    required this.text,
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
  final String text;
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
      ? '${largeNumberFormatter(widget.hates)} dislikes'
      : '${largeNumberFormatter(widget.hates)} dislike';

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
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.decelerate,
                  opacity: isSelected ? 1 : 0.75,
                  child: AnimatedContainer(
                    width: double.infinity,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.decelerate,
                    height: isSelected ? constraints.maxHeight : constraints.maxHeight * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
                      color: Theme.of(context).colorScheme.background,
                      border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8,strokeAlign: BorderSide.strokeAlignCenter),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius),
                                topRight:
                                    Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
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
                                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: HeaderGroupText(
                                  small: true,
                                  expandsTopText: true,
                                  onSecondaryColors: false,
                                  multiLine: true,
                                  spaceBetween: 20,
                                  left: true,
                                  header: widget.title.isEmpty ? widget.text : widget.title,
                                  body: '${widget.university}, Year ${widget.year}',
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
