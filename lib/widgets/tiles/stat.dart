import 'package:Confessi/constants/typography.dart';
import 'package:Confessi/widgets/text/group.dart';
import 'package:flutter/material.dart';

// import '../../constants/typography.dart';
// import '../text/group.dart';

class StatTile extends StatelessWidget {
  const StatTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              flex: 2,
              child: GroupText(
                small: true,
                body: "How many posts of yours have reached \"hottest\".",
                header: "Hots",
                leftAlign: true,
              ),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "15k",
                    style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
