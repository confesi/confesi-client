import 'package:flutter/cupertino.dart';

import '../../../core/results/exceptions.dart';
import '../../../domain/shared/entities/badge.dart';

List<BadgeEntity> badgeConverter(List badges) {
  List<BadgeEntity> badgesConverted = [];
  for (var badge in badges) {
    switch (badge) {
      case 'LOVED':
        badgesConverted.add(
          const BadgeEntity(
            icon: CupertinoIcons.heart,
            text: 'Loved',
          ),
        );
        break;
      case 'HATED':
        badgesConverted.add(
          const BadgeEntity(
            icon: CupertinoIcons.flag,
            text: 'Hated',
          ),
        );
        break;
      case 'CONTROVERSIAL':
        badgesConverted.add(
          const BadgeEntity(
            icon: CupertinoIcons.speaker_1,
            text: 'Controversial',
          ),
        );
        break;
      case 'ENGAGING':
        badgesConverted.add(
          const BadgeEntity(
            icon: CupertinoIcons.chat_bubble,
            text: 'Engaging',
          ),
        );
        break;
      case 'FIRE':
        badgesConverted.add(
          const BadgeEntity(
            icon: CupertinoIcons.flame,
            text: 'On Fiiiiiire',
          ),
        );
        break;
      default:
        throw ServerException();
    }
  }
  return badgesConverted;
}
