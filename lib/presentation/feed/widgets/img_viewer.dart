import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/presentation/shared/buttons/pop.dart';
import 'package:confesi/presentation/shared/other/zoomable.dart';

import '../../primary/widgets/scroll_dots.dart';

class KeepWidgetAlive extends StatefulWidget {
  const KeepWidgetAlive({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  KeepWidgetAliveState createState() => KeepWidgetAliveState();
}

class KeepWidgetAliveState extends State<KeepWidgetAlive> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class MyImageSource {
  final String? url;
  final File? file;

  MyImageSource({this.url, this.file});

  bool get isNetworkImage => url != null;
}

class ImgViewer extends StatefulWidget {
  const ImgViewer({super.key, required this.imageSources, required this.isBlurred, this.heroAnimPrefix});

  final List<MyImageSource> imageSources;
  final bool isBlurred;
  final String? heroAnimPrefix;

  @override
  State<ImgViewer> createState() => _ImgViewerState();
}

class _ImgViewerState extends State<ImgViewer> {
  int currentIdx = 0;
  late bool isBlurred;
  late String heroTag;

  @override
  void initState() {
    isBlurred = widget.isBlurred;
    heroTag = const Uuid().v4();
    super.initState();
  }

  int heroCounter = 0;

  @override
  Widget build(BuildContext context) {
    return widget.imageSources.isEmpty
        ? const SizedBox()
        : LayoutBuilder(
            builder: (context, constraints) {
              double height = MediaQuery.of(context).size.width;
              return Container(
                height: height, // use the height
                color: Theme.of(context).colorScheme.surface,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.bottomCenter,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Haptics.f(H.regular);
                        !isBlurred
                            ? router.push("/img",
                                extra: ImgProps(widget.imageSources[currentIdx], isBlurred, "$heroTag$currentIdx"))
                            : null;
                      },
                      child: PageView(
                        physics: const ClampingScrollPhysics(),
                        onPageChanged: (v) => setState(() => currentIdx = v),
                        children: widget.imageSources.map((imageSource) {
                          if (heroCounter == widget.imageSources.length) heroCounter = 0;
                          return KeepWidgetAlive(
                            child: Hero(
                              tag: "$heroTag${heroCounter++}",
                              child: imageSource.isNetworkImage
                                  ? CachedNetworkImage(
                                      imageUrl: imageSource.url!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      imageSource.file!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ScrollDots(
                        pageLength: widget.imageSources.length,
                        pageIndex: currentIdx,
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        borderColor: Theme.of(context).colorScheme.primary,
                        bgColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

class ImgProps {
  final MyImageSource imageSource;
  final bool isBlurred;
  final String heroTag;

  ImgProps(this.imageSource, this.isBlurred, this.heroTag);
}

class ImgView extends StatefulWidget {
  const ImgView({super.key, required this.props});

  final ImgProps props;

  @override
  ImgViewState createState() => ImgViewState();
}

class ImgViewState extends State<ImgView> {
  late bool blur;

  @override
  void initState() {
    blur = widget.props.isBlurred;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        color: Theme.of(context).colorScheme.shadow,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                color: Theme.of(context).colorScheme.shadow,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Zoomable(
                    clip: false,
                    child: Hero(
                      tag: widget.props.heroTag,
                      child: widget.props.imageSource.isNetworkImage
                          ? CachedNetworkImage(
                              imageUrl: widget.props.imageSource.url!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              widget.props.imageSource.file!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              right: 0,
              left: 0,
              child: SafeArea(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Material(
                    color: Colors.transparent,
                    child: PopButton(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onSecondary,
                      text: "Back",
                      onPress: () => router.pop(),
                      icon: Icons.smart_button,
                      justText: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
