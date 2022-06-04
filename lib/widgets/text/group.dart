import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class GroupText extends StatelessWidget {
  const GroupText({required this.body, required this.header, this.widthMultiplier = 100, Key? key})
      : super(key: key);

  final int widthMultiplier;
  final String header;
  final String body;

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width / 100;
    return SizedBox(
      width: widthFactor * widthMultiplier,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            header,
            style: kHeader,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: kBody,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
