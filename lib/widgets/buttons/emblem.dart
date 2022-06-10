import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

class EmblemButton extends StatelessWidget {
  const EmblemButton(
      {required this.backgroundColor,
      required this.icon,
      required this.onPress,
      required this.iconColor,
      this.loading = false,
      Key? key})
      : super(key: key);

  final bool loading;
  final VoidCallback onPress;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

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
          padding: const EdgeInsets.all(9),
          child: AnimatedSwitcher(
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
        ),
      ),
    );
  }
}
