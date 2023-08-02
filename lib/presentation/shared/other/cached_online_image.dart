import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../indicators/loading_cupertino.dart';

class CachedOnlineImage extends StatelessWidget {
  const CachedOnlineImage({
    super.key,
    this.isCircle = false,
    required this.url,
  });

  final String url;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(isCircle ? 500 : 0)),
      child: CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 250),
        fit: BoxFit.cover,
        imageUrl: url,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surface,
          child: LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.onSurface),
        ),
        errorWidget: (context, url, error) => Center(
          child: Text(
            "Error loading image",
            style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
