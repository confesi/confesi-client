import 'package:flutter/material.dart';

import '../../constants/typography.dart';
import 'touchable_opacity.dart';

class PostButton extends StatelessWidget {
  const PostButton({required this.onPress, required this.icon, required this.value, Key? key})
      : super(key: key);

  final IconData icon;
  final dynamic value;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => onPress(),
      child: Container(
        // container hitbox trick
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                value.toString(),
                style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
