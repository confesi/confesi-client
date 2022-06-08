import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({required this.header, required this.body, Key? key})
      : super(key: key);

  final String header;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: TouchableOpacity(
          onTap: () => print("tap"),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header,
                      style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      body,
                      style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                Icon(CupertinoIcons.chevron_forward,
                    color: Theme.of(context).colorScheme.onSurface),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
