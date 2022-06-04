import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/colors.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({required this.onPress, required this.text, Key? key}) : super(key: key);

  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onPress,
      child: Container(
        decoration: const BoxDecoration(
            color: kPrimary, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.refresh,
                color: kWhite,
                size: 16,
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  text,
                  style: kBody.copyWith(color: kWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
