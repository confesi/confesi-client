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
    /// Dont't forget this
    super.build(context);

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

  @override
  void initState() {
    isBlurred = widget.isBlurred;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.imgUrls.isEmpty
        ? const SizedBox()
        : AspectRatio(
            aspectRatio: 4 / 5,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.8,
                  ),
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.8,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () => router.push("/img",
                        extra: ImgProps(widget.imgUrls[currentIdx], isBlurred, widget.heroAnimPrefix, currentIdx)),
                    child: PageView(
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (v) => setState(() => currentIdx = v),
                      children: widget.imgUrls.map((e) {
                        return KeepWidgetAlive(
                          child: Hero(
                            tag: "img${widget.imgUrls[currentIdx]}${widget.heroAnimPrefix}$currentIdx",
                            child: CachedOnlineImage(
                              url: e,
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

// [Rest of your code including ImgView]

class ImgView extends StatefulWidget {
  const ImgView({super.key, required this.props});

  final ImgProps props;

  @override
  _ImgViewState createState() => _ImgViewState();
}

class _ImgViewState extends State<ImgView> {
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
                      tag: "img${widget.props.url}${widget.props.heroAnimPrefix}${widget.props.idx}",
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
