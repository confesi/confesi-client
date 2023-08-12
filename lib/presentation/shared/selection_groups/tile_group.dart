import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';

class TileGroup extends StatelessWidget {
  const TileGroup({
    super.key,
    required this.text,
    required this.tiles,
  });

  final List<Widget> tiles;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.left,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius)),
            ),
            child: Column(
              children: tiles,
            ),
          )
        ],
      ),
    );
  }
}
