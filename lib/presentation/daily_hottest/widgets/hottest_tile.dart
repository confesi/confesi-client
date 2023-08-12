import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:confesi/presentation/shared/other/cached_online_image.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
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
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.decelerate,
                  opacity: isSelected ? 1 : 0.75,
                  child: AnimatedContainer(
                    width: double.infinity,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.decelerate,
                    height: isSelected ? constraints.maxHeight : constraints.maxHeight * .92,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                          Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius)),
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
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius),
                                topRight: Radius.circular(
                                    Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius)),
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
                            widget.post.post.school.name,
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
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius),
                                bottomRight: Radius.circular(
                                    Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius),
                              ),
                              child: CachedOnlineImage(url: widget.post.post.school.imgUrl),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                right: 15,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: InitScale(
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          colors: [
                                            Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
                                            Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                                            Theme.of(context).colorScheme.tertiary,
                                          ], // Replace with your desired gradient colors
                                          stops: const [0.0, 0.5, 1.0],
                                        ).createShader(bounds);
                                      },
                                      child: Text(
                                        '0${widget.thisIndex + 1}',
                                        style: kFaded.copyWith(
                                          color: Colors.white,
                                        ), // Use white color as the gradient will apply the colors
                                      ),
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
              ],
            ),
          ),
        );
      }),
    );
  }
}
