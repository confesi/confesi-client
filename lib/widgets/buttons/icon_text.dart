import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({required this.text, required this.icon, this.atBottom = false, Key? key})
      : super(key: key);

  final bool atBottom;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("group clicked"),
      child: Container(
        // transparent color trick to increase hitbox size
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: atBottom ? 15 : 30),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                CupertinoIcons.chevron_forward,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
