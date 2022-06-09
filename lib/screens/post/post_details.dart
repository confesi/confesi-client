import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/details.dart';
import 'package:flutter_mobile_client/widgets/buttons/long.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/text/animated_load.dart';
import 'package:flutter_mobile_client/widgets/text/link.dart';
import 'package:flutter_mobile_client/widgets/text/row.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TouchableOpacity(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.transparent,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(CupertinoIcons.chevron_back),
                      ),
                    ),
                  ),
                  Text(
                    "Post details",
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CupertinoIcons.chevron_back, color: Colors.transparent),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                primary: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      const DetailsButton(
                        header: "Genre",
                        body: "relationships",
                      ),
                      const DetailsButton(
                        header: "Link a friend",
                        body: "@thatguy69",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Hero(
                          tag: "details-button",
                          child: Material(
                            child: LongButton(
                              text: "Done",
                              onPress: () => Navigator.of(context).pop(),
                              textColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const RowText(
                                leftText: "University",
                                rightText: "university of victoria",
                                topLine: true),
                            const RowText(leftText: "Faculty", rightText: "computer science"),
                            const RowText(leftText: "Year", rightText: "two"),
                            const SizedBox(height: 26),
                            LinkText(
                              text: "These details are auto-populated from your account. ",
                              linkText: "Change them here.",
                              widthMultiplier: 67,
                              onPress: () {
                                print("TAP!");
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
