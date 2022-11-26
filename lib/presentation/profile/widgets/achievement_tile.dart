import 'package:Confessi/application/shared/cubit/share_cubit.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet_with_action.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/indicators/loading.dart';

class AchievementTile extends StatelessWidget {
  const AchievementTile({
    super.key,
    required this.title,
    required this.aspectRatio,
    required this.achievementImgUrl,
    required this.description,
    required this.quantity,
    required this.rarity,
  });

  final String rarity;
  final String achievementImgUrl;
  final String title;
  final String description;
  final int quantity;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showInfoSheetWithAction(
        context,
        "$title (x$quantity, $rarity)",
        description,
        () => context.read<ShareCubit>().shareContent(
            context, "I got the $title (x$quantity) achievement on Confesi!", "Check out this achievement!"),
        "Share with friends",
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7.5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
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
    );
  }
}
