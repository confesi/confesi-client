import 'package:cached_network_image/cached_network_image.dart';
import 'package:confesi/constants/shared/constants.dart';
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
  }) : super(key: key);

  final String url;
  final bool isCircle;
  final BoxFit fit;
  final bool isBlurred;
  final Function(bool blur)? onBlur;

  @override
  CachedOnlineImageState createState() => CachedOnlineImageState();
}

class CachedOnlineImageState extends State<CachedOnlineImage> {
  String _ensureHttpsUrl(String inputUrl) {
    if (!inputUrl.startsWith('https://') && !inputUrl.startsWith('http://')) {
      return 'https://$inputUrl';
    }
    return inputUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget.isCircle ? 500 : 0)),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 75),
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
                imageBuilder: (context, imageProvider) => widget.isBlurred
                    ? ImageFiltered(
                        imageFilter:
                            ui.ImageFilter.blur(sigmaX: imgBlurSigma, sigmaY: imgBlurSigma, tileMode: TileMode.mirror),
                        child: Image(
                          image: imageProvider,
                          fit: widget.fit,
                        ),
                      )
                    : Image(
                        image: imageProvider,
                        fit: widget.fit,
                      ),
              ),
            ),
            if (widget.isBlurred && widget.onBlur != null)
              Positioned.fill(
                child: Container(
                  child: TouchableScale(
                    onTap: () => widget.onBlur!(false),
                    child: Center(
                        child: Icon(CupertinoIcons.eye_solid, color: Theme.of(context).colorScheme.primary, size: 30)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
