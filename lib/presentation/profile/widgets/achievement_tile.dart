import '../../../application/shared/cubit/share_cubit.dart';
import '../../../constants/profile/enums.dart';
import '../../../core/converters/achievement_rarity_to_color.dart';
import '../../../core/converters/achievement_rarity_to_string.dart';
import '../overlays/achievement_sheet.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';
import '../../shared/overlays/info_sheet_with_action.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/indicators/loading_material.dart';

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

  final AchievementRarity rarity;
  final String achievementImgUrl;
  final String title;
  final String description;
  final int quantity;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => showAchievementSheet(context, rarity, title, description, quantity),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: achievementImgUrl,
              placeholder: (context, url) => Container(
                color: Theme.of(context).colorScheme.surface,
                child: LoadingCupertinoIndicator(
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
    );
  }
}
