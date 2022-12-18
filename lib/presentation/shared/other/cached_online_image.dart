import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../indicators/loading_cupertino.dart';

class CachedOnlineImage extends StatelessWidget {
  const CachedOnlineImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surface,
          child: LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.onSurface)),
      errorWidget: (context, url, error) => Container(
        color: Theme.of(context).colorScheme.surface,
        child: Icon(Icons.error, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
