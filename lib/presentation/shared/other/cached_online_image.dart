import 'package:cached_network_image/cached_network_image.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/styles/typography.dart';
import '../indicators/loading_cupertino.dart';
import 'dart:ui' as ui;

class CachedOnlineImage extends StatefulWidget {
  const CachedOnlineImage({
    Key? key,
    this.isCircle = false,
    required this.url,
    this.fit = BoxFit.cover,
    this.isBlurred = false,
    this.onBlur,
    this.onChangeBlurringSettings,
  }) : super(key: key);

  final String url;
  final bool isCircle;
  final BoxFit fit;
  final bool isBlurred;
  final Function(bool blur)? onBlur;
  final Function()? onChangeBlurringSettings;

  @override
  CachedOnlineImageState createState() => CachedOnlineImageState();
}

class CachedOnlineImageState extends State<CachedOnlineImage> with TickerProviderStateMixin {
  late final AnimationController _blurAnimationController;
  late final Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();

    _blurAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
        setState(() {}); // This will trigger a rebuild whenever the animation value changes
      });

    _blurAnimation = Tween<double>(
      begin: widget.isBlurred ? imgBlurSigma : 0,
      end: 0,
    ).animate(_blurAnimationController);
  }

  @override
  void dispose() {
    _blurAnimationController.dispose();
    super.dispose();
  }

  String _ensureHttpsUrl(String inputUrl) {
    if (!inputUrl.startsWith('https://') && !inputUrl.startsWith('http://')) {
      return 'https://$inputUrl';
    }
    return inputUrl;
  }

  Widget _buildUnblurContainer() {
    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
          width: 0.8,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TouchableScale(
            onTap: () {
              _blurAnimationController.forward();
              widget.onBlur!(false);
            },
            child: Text(
              "Temporary unblur 👀",
              style: kTitle.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 15),
          TouchableScale(
            onTap: () => router.push('/settings/filters'),
            child: Text(
              "Update blur settings ->",
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget.isCircle ? 500 : 0)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 25),
                fit: widget.fit,
                imageUrl: _ensureHttpsUrl(widget.url),
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(child: LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.onSurface)),
                ),
                errorWidget: (context, url, error) => SafeArea(
                  bottom: false,
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Text(
                        "Error loading image",
                        style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                ),
                imageBuilder: (context, imageProvider) {
                  List<Widget> stackChildren = [];

                  stackChildren.add(
                    Positioned.fill(
                      child: ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(
                          sigmaX: _blurAnimation.value,
                          sigmaY: _blurAnimation.value,
                          tileMode: TileMode.mirror,
                        ),
                        child: Image(
                          image: imageProvider,
                          fit: widget.fit,
                        ),
                      ),
                    ),
                  );

                  stackChildren.add(
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 75),
                      child: (_blurAnimation.value == imgBlurSigma && widget.onBlur != null)
                          ? _buildUnblurContainer()
                          : const SizedBox.shrink(
                              key: ValueKey("sbox"),
                            ), // Display nothing if condition is false
                    ),
                  );

                  return Stack(
                    alignment: Alignment.center,
                    children: stackChildren,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
