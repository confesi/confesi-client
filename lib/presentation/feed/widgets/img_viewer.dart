import 'package:cached_network_image/cached_network_image.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/primary/widgets/scroll_dots.dart';
import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:confesi/presentation/shared/buttons/pop.dart';
import 'package:confesi/presentation/shared/other/cached_online_image.dart';
import 'package:confesi/presentation/shared/other/zoomable.dart';
import 'package:confesi/presentation/shared/overlays/screen_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
    super.build(context); // Don't forget this
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class ImgViewer extends StatefulWidget {
  const ImgViewer({super.key, required this.imgUrls, required this.isBlurred, this.heroAnimPrefix});

  final List<String> imgUrls;
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

  @override
  Widget build(BuildContext context) {
    return widget.imgUrls.isEmpty
        ? const SizedBox()
        : AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () => !isBlurred
                        ? router.push("/img",
                            extra: ImgProps(
                              widget.imgUrls[currentIdx],
                              isBlurred,
                              heroTag,
                            ))
                        : null,
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (v) => setState(() => currentIdx = v),
                      children: widget.imgUrls.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String imgUrl = entry.value;
                        return KeepWidgetAlive(
                          child: Hero(
                            tag: heroTag,
                            child: CachedOnlineImage(
                              url: imgUrl,
                              isBlurred: isBlurred,
                              fit: BoxFit.fitWidth,
                              onBlur: (blur) => setState(() => isBlurred = blur),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ScrollDots(
                      pageLength: widget.imgUrls.length,
                      pageIndex: currentIdx,
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      borderColor: Theme.of(context).colorScheme.primary,
                      bgColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
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
                height: heightFraction(context, 1),
                child: Center(
                  child: Zoomable(
                    clip: false,
                    child: Hero(
                      tag: widget.props.heroTag,
                      child: CachedOnlineImage(
                        isBlurred: blur,
                        fit: BoxFit.fitWidth,
                        url: widget.props.url,
                        onBlur: (b) => setState(() => blur = b),
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
