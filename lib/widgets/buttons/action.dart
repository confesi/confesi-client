import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {required this.backgroundColor,
      required this.icon,
      required this.onPress,
      required this.text,
      required this.iconColor,
      required this.textColor,
      this.loading = false,
      this.large = false,
      Key? key})
      : super(key: key);

  final bool loading;
  final String text;
  final VoidCallback onPress;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: large ? 15 : 11, vertical: large ? 12 : 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: large ? MainAxisSize.max : MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: loading
                    ? Padding(
                        padding: const EdgeInsets.all(2),
                        child: CupertinoActivityIndicator(
                          radius: 8,
                          color: iconColor,
                        ),
                      )
                    : Icon(
                        icon,
                        color: iconColor,
                        size: 20,
                      ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 3, top: 1),
                child: Text(
                  text,
                  style: kBody.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
