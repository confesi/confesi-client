import 'package:flutter/cupertino.dart';

import '../../../core/results/exceptions.dart';
import '../../../domain/shared/entities/badge.dart';

List<Badge> badgeConverter(List badges) {
  List<Badge> badgesConverted = [];
  for (var badge in badges) {
    switch (badge) {
      case 'LOVED':
        badgesConverted.add(
          const Badge(
            icon: CupertinoIcons.heart,
            text: 'Loved',
          ),
        );
        break;
      case 'HATED':
        badgesConverted.add(
          const Badge(
            icon: CupertinoIcons.flag,
            text: 'Hated',
          ),
        );
        break;
      case 'CONTROVERSIAL':
        badgesConverted.add(
          const Badge(
            icon: CupertinoIcons.speaker_1,
            text: 'Controversial',
          ),
        );
        break;
      case 'ENGAGING':
        badgesConverted.add(
          const Badge(
            icon: CupertinoIcons.chat_bubble,
            text: 'Engaging',
          ),
        );
        break;
      case 'FIRE':
        badgesConverted.add(
          const Badge(
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
