import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/shared/other/cached_online_image.dart';

import '../../../core/styles/typography.dart';

import 'package:flutter/material.dart';

import '../../shared/text/header_group.dart';

class HottestTile extends StatefulWidget {
  const HottestTile({
    required this.currentIndex,
    required this.thisIndex,
    required this.post,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final int thisIndex;
  final Post post;

  @override
  State<HottestTile> createState() => _HottestTileState();
}

class _HottestTileState extends State<HottestTile> {
  bool get isSelected => widget.currentIndex == widget.thisIndex;

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
                    height: isSelected ? constraints.maxHeight : constraints.maxHeight * .9,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context).colorScheme.background,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.8,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            color: Theme.of(context).colorScheme.secondary,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondary,
                                blurRadius: 15,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            widget.post.school.name,
                            style: kTitle.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: CachedOnlineImage(
                                url: widget.post.school.imgUrl,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
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
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: HeaderGroupText(
                                  small: true,
                                  expandsTopText: true,
                                  onSecondaryColors: false,
                                  multiLine: true,
                                  spaceBetween: 15,
                                  left: true,
                                  header: widget.post.title.isEmpty ? widget.post.content : widget.post.title,
                                  body:
                                      '${widget.post.emojis.join('  ')}${widget.post.yearOfStudy.type != null ? "\nYear ${widget.post.yearOfStudy.type}" : ''}${widget.post.faculty.faculty != null ? "\n${widget.post.faculty.faculty}" : ''}',
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
