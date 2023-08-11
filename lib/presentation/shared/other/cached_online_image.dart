import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../indicators/loading_cupertino.dart';

class CachedOnlineImage extends StatelessWidget {
  const CachedOnlineImage({
    Key? key,
    this.isCircle = false,
    required this.url,
  }) : super(key: key);

  final String url;
  final bool isCircle;

  String _ensureHttpsUrl(String inputUrl) {
    if (!inputUrl.startsWith('https://') && !inputUrl.startsWith('http://')) {
      return 'https://$inputUrl';
    }
    return inputUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(isCircle ? 500 : 0)),
      child: CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 250),
        fit: BoxFit.cover,
        imageUrl: _ensureHttpsUrl(url),
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surface,
          child: LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.onSurface),
        ),
        errorWidget: (context, url, error) => SafeArea(
          bottom: false,
          child: Center(
            child: Text(
              "Error loading image",
              style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
