import 'package:Confessi/core/styles/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../shared/indicators/loading.dart';

class AchievementTile extends StatelessWidget {
  const AchievementTile({
    super.key,
    required this.title,
    required this.aspectRatio,
    required this.achievementImgUrl,
    required this.description,
    required this.quantity,
    required this.heroId,
  });

  final int heroId;
  final String achievementImgUrl;
  final String title;
  final String description;
  final int quantity;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        "/home/profile/achievement_details",
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7.5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              // borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Hero(
                tag: heroId,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: achievementImgUrl,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: LoadingIndicator(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Icon(Icons.error, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
