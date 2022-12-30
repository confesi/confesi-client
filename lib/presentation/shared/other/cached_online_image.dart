import 'package:Confessi/constants/authentication_and_settings/text.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.exclamationmark_circle, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Error loading image",
                style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
