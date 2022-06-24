import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({this.bottomPadding = 15, required this.text, required this.icon, Key? key})
      : super(key: key);

  final String text;
  final IconData icon;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("group clicked"),
      child: Container(
        // transparent color trick to increase hitbox size
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
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
                size: 24,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
