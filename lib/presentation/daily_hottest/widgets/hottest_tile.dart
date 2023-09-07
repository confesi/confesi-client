import 'package:confesi/constants/shared/constants.dart';
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
  final PostWithMetadata post;

  @override
  State<HottestTile> createState() => _HottestTileState();
}

class _HottestTileState extends State<HottestTile> {
  bool get isSelected => widget.currentIndex == widget.thisIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.decelerate,
                    opacity: isSelected ? 1 : 0.75,
                    child: AnimatedContainer(
                      // box constraints max width
                      constraints: const BoxConstraints(maxWidth: maxStandardSizeOfContent),
                      width: double.infinity,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.decelerate,
                      height: isSelected ? constraints.maxHeight : constraints.maxHeight * .92,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: borderSize,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        borderRadius: BorderRadius.circular(10.0), // Added rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              widget.post.post.school.name,
                              style: kTitle.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: double.infinity,
                              child: CachedOnlineImage(url: widget.post.post.school.imgUrl),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned.fill(
                                  right: 15,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      '0${widget.thisIndex + 1}',
                                      style: kFaded.copyWith(
                                        color: Theme.of(context).colorScheme.surface,
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
                                    header: widget.post.post.title.isEmpty
                                        ? widget.post.post.content
                                        : widget.post.post.title,
                                    body:
                                        '${widget.post.emojis.join('  ')}${widget.post.post.yearOfStudy.type != null ? "\nYear ${widget.post.post.yearOfStudy.type}" : ''}${widget.post.post.faculty.faculty != null ? "\n${widget.post.post.faculty.faculty}" : ''}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
